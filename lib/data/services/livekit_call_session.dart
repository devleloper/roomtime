import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../core/log/dev_log.dart';
import '../../domain/entities/call_snapshot.dart';
import '../../domain/failures/failure.dart';
import '../../domain/services/call_session.dart';
import 'call_foreground_service.dart';
import 'livekit_room_driver.dart';

/// [CallSession] on LiveKit. One instance per call (registered as factory).
///
/// Resource rule: a media room (through [MediaRoomDriver]) and its local
/// tracks are created in [connect] and released exactly once by [_tearDown]
/// (leave, remote disconnect, failed connect or dispose). After every await
/// in the connect path the session checks that its room is still current, so
/// nothing is published into a room that was torn down meanwhile.
@Injectable(as: CallSession)
class LiveKitCallSession implements CallSession {
  LiveKitCallSession(
    this._foregroundService, {
    @ignoreParam MediaRoomDriver Function()? createDriver,
    @ignoreParam bool Function()? canSwitchSpeakerphone,
    @ignoreParam bool Function()? speakerPreferred,
  }) : _createDriver = createDriver ?? LiveKitRoomDriver.new,
       _canSwitchSpeakerphone =
           canSwitchSpeakerphone ??
           (() => lk.AudioManager.instance.canSwitchSpeakerphone),
       _speakerPreferred =
           speakerPreferred ??
           (() => lk.AudioManager.instance.isSpeakerOutputPreferred);

  final CallForegroundService _foregroundService;
  final MediaRoomDriver Function() _createDriver;
  final bool Function() _canSwitchSpeakerphone;
  final bool Function() _speakerPreferred;
  final _snapshots = StreamController<CallSnapshot>.broadcast();

  CallSnapshot _snapshot = const CallSnapshot();
  CallConnection _connection = CallConnection.idle;
  MediaRoomDriver? _room;
  Future<void>? _connectAttempt;
  Future<void>? _teardown;
  bool _leaveRequested = false;
  bool _disposed = false;
  bool _frontCamera = true;
  bool _microphoneFailed = false;

  @override
  Stream<CallSnapshot> get snapshots => _snapshots.stream;

  @override
  CallSnapshot get snapshot => _snapshot;

  @override
  bool get canSwitchAudioOutput => _canSwitchSpeakerphone();

  @override
  Future<void> connect(CallConnectOptions options) async {
    // Left before the media connection even started: nothing to release.
    if (_leaveRequested || _disposed) return;
    if (_room != null) throw StateError('CallSession is already connected');

    final room = _createDriver();
    _room = room;
    _teardown = null;
    room.listen((event) => _onRoomEvent(room, event));
    _connection = CallConnection.connecting;
    _refresh();

    // leave() waits for this whole attempt (connect + publishing), so no track
    // can be created after the teardown.
    final attempt = Completer<void>();
    _connectAttempt = attempt.future;
    try {
      await _connectAndPublish(room, options);
    } finally {
      _connectAttempt = null;
      attempt.complete();
    }
  }

  /// The room is still the session's room and nobody asked to leave.
  bool _isCurrent(MediaRoomDriver room) =>
      !_leaveRequested && identical(_room, room);

  Future<void> _connectAndPublish(
    MediaRoomDriver room,
    CallConnectOptions options,
  ) async {
    // Tracks are published after connect, not via FastConnectOptions: a
    // failing camera inside the SDK's join handler would abort the whole join,
    // and here every step can stop when the user left meanwhile.
    try {
      await room.connect(options.url, options.token);
    } on Object catch (error, stackTrace) {
      _log('connect failed', error, stackTrace);
      await _tearDown(CallEndReason.connectionLost);
      if (_leaveRequested) return;
      _teardown = null; // allow a retry with a new room
      throw connectFailure(error);
    }
    if (_leaveRequested) return _tearDown(CallEndReason.left);
    // Disconnected by the server right after joining; already torn down.
    if (!identical(_room, room)) return;

    _connection = CallConnection.connected;
    unawaited(_foregroundService.start());
    if (options.microphoneEnabled) {
      _microphoneFailed = !await _enableTrack(
        room,
        () => room.setMicrophoneEnabled(true),
      );
    }
    if (options.cameraEnabled && _isCurrent(room)) {
      await _enableTrack(room, () => room.setCameraEnabled(true));
    }
    if (_leaveRequested) return _tearDown(CallEndReason.left);
    if (identical(_room, room)) _refresh();
  }

  /// False when the device could not be opened. Joining without it beats
  /// not joining; the snapshot shows the track as off.
  Future<bool> _enableTrack(
    MediaRoomDriver room,
    Future<void> Function() enable,
  ) async {
    if (!_isCurrent(room)) return true;
    try {
      await enable();
      return true;
    } on Object catch (error, stackTrace) {
      _log('could not enable a local track', error, stackTrace);
      return false;
    }
  }

  @override
  Future<void> leave() async {
    _leaveRequested = true;
    final attempt = _connectAttempt;
    if (attempt != null) await attempt;
    await _tearDown(CallEndReason.left);
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await leave();
    await _snapshots.close();
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) => _media((room) async {
    try {
      await room.setMicrophoneEnabled(enabled);
      _microphoneFailed = false;
    } on Object {
      if (enabled) _microphoneFailed = true;
      rethrow;
    }
  });

  @override
  Future<void> setCameraEnabled(bool enabled) =>
      _media((room) => room.setCameraEnabled(enabled));

  @override
  Future<void> flipCamera() => _media((room) async {
    final switched = await room.switchCamera(front: !_frontCamera);
    if (switched) _frontCamera = !_frontCamera;
  });

  @override
  Future<void> setSpeakerphoneOn(bool on) =>
      _media((_) => lk.AudioManager.instance.setSpeakerOutputPreferred(on));

  @override
  Future<void> startAudio() => _media((room) => room.startAudio());

  /// Runs a command on the current room; every error becomes a [Failure].
  Future<void> _media(
    Future<void> Function(MediaRoomDriver room) action,
  ) async {
    final room = _room;
    if (room == null) return;
    try {
      await action(room);
    } on Object catch (error, stackTrace) {
      _log('media command failed', error, stackTrace);
      throw const MediaDeviceFailure();
    } finally {
      _refresh();
    }
  }

  void _onRoomEvent(MediaRoomDriver room, MediaRoomEvent event) {
    if (!identical(_room, room)) return;
    switch (event) {
      case MediaRoomDisconnected(:final reason):
        unawaited(_tearDown(reason));
        return;
      case MediaRoomReconnecting():
        _connection = CallConnection.reconnecting;
      case MediaRoomReconnected():
        _connection = CallConnection.connected;
      case MediaRoomChanged():
        break;
    }
    _refresh();
  }

  Future<void> _tearDown(CallEndReason reason) =>
      _teardown ??= _releaseRoom(reason);

  Future<void> _releaseRoom(CallEndReason reason) async {
    final room = _room;
    _room = null;
    _connection = CallConnection.disconnected;
    await _foregroundService.stop();
    await room?.close();
    _publish(
      CallSnapshot(
        connection: CallConnection.disconnected,
        endReason: reason,
        frontCamera: _frontCamera,
      ),
    );
  }

  void _refresh() {
    final room = _room;
    if (room == null) return;
    _publish(
      CallSnapshot(
        connection: _connection,
        participants: room.participants(),
        microphoneEnabled: room.microphoneEnabled,
        cameraEnabled: room.cameraEnabled,
        frontCamera: _frontCamera,
        speakerphoneOn: _speakerPreferred(),
        audioPlaybackBlocked: room.audioPlaybackBlocked,
        microphoneUnavailable: _microphoneFailed,
      ),
    );
  }

  void _publish(CallSnapshot next) {
    if (next == _snapshot) return;
    _snapshot = next;
    if (!_snapshots.isClosed) _snapshots.add(next);
  }

  /// The API checks capacity before issuing a token, but two joins racing
  /// for the last seat can both get one; LiveKit then refuses the second.
  /// With `auto_create` off, a room ended meanwhile is refused as unknown.
  /// The old token is never retried: the caller joins again through the API.
  @visibleForTesting
  static Failure connectFailure(Object error) {
    if (error is lk.ConnectException &&
        error.reason == lk.ConnectionErrorReason.NotAllowed) {
      final message = error.message.toLowerCase();
      if (message.contains('full') || message.contains('max participants')) {
        return const RoomFullFailure();
      }
      if (error.statusCode == 404 || message.contains('does not exist')) {
        return const RoomNotFoundFailure();
      }
      // /rtc/validate reports any status >= 400 as NotAllowed, including
      // a restarting media server behind the edge (CR-C7).
      final status = error.statusCode;
      if (status >= 500) return ServerFailure(statusCode: status);
      return UnknownFailure(statusCode: status, code: 'media_refused');
    }
    if (error is lk.LiveKitException) return const NetworkFailure();
    return const UnknownFailure();
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      devLog(
        message,
        name: 'LiveKitCallSession',
        error: error,
        stackTrace: stackTrace,
      );
}
