import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../core/log/dev_log.dart';
import '../../domain/entities/call_snapshot.dart';
import '../datasources/livekit_room_options.dart';

/// Media room events the call session reacts to.
sealed class MediaRoomEvent {
  const MediaRoomEvent();
}

final class MediaRoomDisconnected extends MediaRoomEvent {
  const MediaRoomDisconnected(this.reason);

  final CallEndReason reason;
}

final class MediaRoomReconnecting extends MediaRoomEvent {
  const MediaRoomReconnecting();
}

final class MediaRoomReconnected extends MediaRoomEvent {
  const MediaRoomReconnected();
}

/// Anything that changes participants or tracks.
final class MediaRoomChanged extends MediaRoomEvent {
  const MediaRoomChanged();
}

/// Narrow seam over one LiveKit `Room`, so the session lifecycle (single
/// teardown, leave during connect, remote disconnects) is testable without
/// a media server (CR-C3). Data layer only; never crosses the domain port.
abstract interface class MediaRoomDriver {
  void listen(void Function(MediaRoomEvent event) onEvent);

  Future<void> connect(String url, String token);

  /// Turns a device on (publishing it the first time) or off (mute). A track
  /// opened for publishing is stopped if publishing fails or the driver was
  /// disposed meanwhile, so no device stays captured (CR-C2).
  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> setCameraEnabled(bool enabled);

  /// Switches the published camera; false when there is none.
  Future<bool> switchCamera({required bool front});

  Future<void> startAudio();

  List<CallParticipant> participants();

  bool get microphoneEnabled;
  bool get cameraEnabled;
  bool get audioPlaybackBlocked;

  /// Stops every local track (published or still opening), disconnects and
  /// disposes the room. Idempotent.
  Future<void> close();
}

/// [MediaRoomDriver] on `livekit_client`.
class LiveKitRoomDriver implements MediaRoomDriver {
  LiveKitRoomDriver() : _room = lk.Room(roomOptions: liveKitRoomOptions);

  final lk.Room _room;
  lk.EventsListener<lk.RoomEvent>? _listener;

  /// Tracks opened but not (yet) published; [close] stops them too.
  final _opening = <lk.LocalTrack>{};
  bool _closed = false;
  Future<void>? _closing;

  @override
  void listen(void Function(MediaRoomEvent event) onEvent) {
    _listener = _room.createListener()
      ..listen((event) {
        switch (event) {
          case lk.RoomDisconnectedEvent(:final reason):
            onEvent(MediaRoomDisconnected(endReason(reason)));
          case lk.ReconnectingEvent():
            onEvent(const MediaRoomReconnecting());
          case lk.RoomReconnectedEvent():
            onEvent(const MediaRoomReconnected());
          default:
            onEvent(const MediaRoomChanged());
        }
      });
  }

  @override
  Future<void> connect(String url, String token) => _room.connect(url, token);

  @override
  Future<void> setMicrophoneEnabled(bool enabled) => _setEnabled(
    lk.TrackSource.microphone,
    enabled,
    open: () => lk.LocalAudioTrack.create(
      liveKitRoomOptions.defaultAudioCaptureOptions,
    ),
    publish: (participant, track) =>
        participant.publishAudioTrack(track as lk.LocalAudioTrack),
  );

  @override
  Future<void> setCameraEnabled(bool enabled) => _setEnabled(
    lk.TrackSource.camera,
    enabled,
    open: () => lk.LocalVideoTrack.createCameraTrack(
      liveKitRoomOptions.defaultCameraCaptureOptions,
    ),
    publish: (participant, track) =>
        participant.publishVideoTrack(track as lk.LocalVideoTrack),
  );

  Future<void> _setEnabled(
    lk.TrackSource source,
    bool enabled, {
    required Future<lk.LocalTrack> Function() open,
    required Future<Object?> Function(lk.LocalParticipant, lk.LocalTrack)
    publish,
  }) async {
    final participant = _room.localParticipant;
    if (_closed || participant == null) return;
    final existing = participant.getTrackPublicationBySource(source);
    if (existing != null) {
      // Mute/unmute of a published track: no new device is opened.
      await (enabled ? existing.unmute() : existing.mute());
      return;
    }
    if (!enabled) return;
    final track = await open();
    _opening.add(track);
    try {
      if (_closed) return;
      await publish(participant, track);
    } on Object {
      await _stop(track);
      rethrow;
    } finally {
      _opening.remove(track);
      if (_closed) await _stop(track);
    }
  }

  @override
  Future<bool> switchCamera({required bool front}) async {
    final track = _room.localParticipant?.videoTrackPublications
        .firstWhereOrNull((p) => p.source == lk.TrackSource.camera)
        ?.track;
    if (track == null) return false;
    await track.setCameraPosition(
      front ? lk.CameraPosition.front : lk.CameraPosition.back,
    );
    return true;
  }

  @override
  Future<void> startAudio() => _room.startAudio();

  @override
  bool get microphoneEnabled =>
      _room.localParticipant?.isMicrophoneEnabled() ?? false;

  @override
  bool get cameraEnabled => _room.localParticipant?.isCameraEnabled() ?? false;

  @override
  bool get audioPlaybackBlocked => kIsWeb && !_room.canPlaybackAudio;

  @override
  List<CallParticipant> participants() {
    final local = _room.localParticipant;
    return List.unmodifiable([
      if (local != null) _participant(local, isLocal: true),
      for (final remote in _room.remoteParticipants.values)
        _participant(remote, isLocal: false),
    ]);
  }

  @override
  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _closed = true;
    await _listener?.dispose();
    _listener = null;
    for (final track in List.of(_opening)) {
      await _stop(track);
    }
    try {
      await _room.localParticipant?.unpublishAllTracks(stopOnUnpublish: true);
    } on Object catch (error, stackTrace) {
      _log('unpublish failed', error, stackTrace);
    }
    try {
      await _room.disconnect();
    } on Object catch (error, stackTrace) {
      _log('disconnect failed', error, stackTrace);
    }
    await _room.dispose();
  }

  static Future<void> _stop(lk.LocalTrack track) async {
    try {
      await track.stop();
    } on Object catch (error, stackTrace) {
      _log('track stop failed', error, stackTrace);
    }
  }

  static CallParticipant _participant(
    lk.Participant participant, {
    required bool isLocal,
  }) {
    final videoPublication = participant.videoTrackPublications
        .firstWhereOrNull(
          (p) =>
              p.source == lk.TrackSource.camera && p.track != null && !p.muted,
        );
    final audioPublication = participant.audioTrackPublications
        .firstWhereOrNull((p) => p.source == lk.TrackSource.microphone);
    final dimensions = videoPublication?.dimensions;
    return CallParticipant(
      id: participant.sid,
      identity: participant.identity,
      displayName: participant.name,
      isLocal: isLocal,
      isSpeaking: participant.isSpeaking,
      microphoneEnabled: participant.isMicrophoneEnabled(),
      cameraEnabled: videoPublication != null,
      weakConnection: isWeak(participant.connectionQuality),
      audioTrackSid: audioPublication?.sid,
      videoAspectRatio: dimensions != null && dimensions.height > 0
          ? dimensions.width / dimensions.height
          : null,
      videoTrack: videoPublication?.track,
    );
  }

  /// Quality updates arrive as room events, so the next snapshot carries them.
  @visibleForTesting
  static bool isWeak(lk.ConnectionQuality quality) =>
      quality == lk.ConnectionQuality.poor ||
      quality == lk.ConnectionQuality.lost;

  @visibleForTesting
  static CallEndReason endReason(lk.DisconnectReason? reason) =>
      switch (reason) {
        lk.DisconnectReason.clientInitiated => CallEndReason.left,
        lk.DisconnectReason.participantRemoved => CallEndReason.removed,
        lk.DisconnectReason.roomDeleted => CallEndReason.roomDeleted,
        lk.DisconnectReason.duplicateIdentity => CallEndReason.joinedElsewhere,
        _ => CallEndReason.connectionLost,
      };

  static void _log(String message, Object error, StackTrace stackTrace) =>
      devLog(
        message,
        name: 'LiveKitRoomDriver',
        error: error,
        stackTrace: stackTrace,
      );
}
