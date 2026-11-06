import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/data/services/livekit_room_options.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';

sealed class MediaRoomEvent {
  const MediaRoomEvent();
}

final class MediaRoomDisconnected extends MediaRoomEvent {
  final CallEndReason reason;

  const MediaRoomDisconnected(this.reason);
}

final class MediaRoomReconnecting extends MediaRoomEvent {
  const MediaRoomReconnecting();
}

final class MediaRoomReconnected extends MediaRoomEvent {
  const MediaRoomReconnected();
}

final class MediaRoomChanged extends MediaRoomEvent {
  const MediaRoomChanged();
}

abstract interface class MediaRoomDriver {
  void listen(void Function(MediaRoomEvent event) onEvent);

  Future<void> connect(String url, String token);

  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> setCameraEnabled(bool enabled);

  Future<bool> switchCamera({required bool front});

  Future<void> startAudio();

  List<CallParticipant> participants();

  bool get microphoneEnabled;
  bool get cameraEnabled;
  bool get audioPlaybackBlocked;

  Future<void> close();
}

class LiveKitRoomDriver implements MediaRoomDriver {
  final lk.Room _room;
  lk.EventsListener<lk.RoomEvent>? _listener;

  final _opening = <lk.LocalTrack>{};
  bool _closed = false;
  Future<void>? _closing;

  LiveKitRoomDriver() : _room = lk.Room(roomOptions: liveKitRoomOptions);

  @override
  bool get microphoneEnabled {
    return _room.localParticipant?.isMicrophoneEnabled() ?? false;
  }

  @override
  bool get cameraEnabled {
    return _room.localParticipant?.isCameraEnabled() ?? false;
  }

  @override
  bool get audioPlaybackBlocked => kIsWeb && !_room.canPlaybackAudio;

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
  Future<void> connect(String url, String token) {
    return _room.connect(url, token);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) {
    return _setEnabled(
      lk.TrackSource.microphone,
      enabled,
      open: () => lk.LocalAudioTrack.create(
        liveKitRoomOptions.defaultAudioCaptureOptions,
      ),
      publish: (participant, track) =>
          participant.publishAudioTrack(track as lk.LocalAudioTrack),
    );
  }

  @override
  Future<void> setCameraEnabled(bool enabled) {
    return _setEnabled(
      lk.TrackSource.camera,
      enabled,
      open: () => lk.LocalVideoTrack.createCameraTrack(
        liveKitRoomOptions.defaultCameraCaptureOptions,
      ),
      publish: (participant, track) =>
          participant.publishVideoTrack(track as lk.LocalVideoTrack),
    );
  }

  @override
  Future<bool> switchCamera({required bool front}) async {
    final track = _room.localParticipant?.videoTrackPublications
        .firstWhereOrNull((p) => p.source == lk.TrackSource.camera)
        ?.track;
    if (track == null) {
      return false;
    }

    final position = front ? lk.CameraPosition.front : lk.CameraPosition.back;
    await track.setCameraPosition(position);
    return true;
  }

  @override
  Future<void> startAudio() {
    return _room.startAudio();
  }

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
  Future<void> close() {
    if (_closing == null) {
      _closing = _close();
    }
    return _closing!;
  }

  @visibleForTesting
  static bool isWeak(lk.ConnectionQuality quality) {
    return quality == lk.ConnectionQuality.poor ||
        quality == lk.ConnectionQuality.lost;
  }

  @visibleForTesting
  static CallEndReason endReason(lk.DisconnectReason? reason) {
    return switch (reason) {
      lk.DisconnectReason.clientInitiated => CallEndReason.left,
      lk.DisconnectReason.participantRemoved => CallEndReason.removed,
      lk.DisconnectReason.roomDeleted => CallEndReason.roomDeleted,
      lk.DisconnectReason.duplicateIdentity => CallEndReason.joinedElsewhere,
      _ => CallEndReason.connectionLost,
    };
  }

  Future<void> _setEnabled(
    lk.TrackSource source,
    bool enabled, {
    required Future<lk.LocalTrack> Function() open,
    required Future<Object?> Function(lk.LocalParticipant, lk.LocalTrack)
    publish,
  }) async {
    final participant = _room.localParticipant;
    if (_closed || participant == null) {
      return;
    }

    final existing = participant.getTrackPublicationBySource(source);
    if (existing != null) {
      if (enabled) {
        await existing.unmute();
      } else {
        await existing.mute();
      }
      return;
    }

    if (!enabled) {
      return;
    }

    final track = await open();
    _opening.add(track);
    try {
      if (_closed) {
        return;
      }
      await publish(participant, track);
    } on Object {
      await _stop(track);
      rethrow;
    } finally {
      _opening.remove(track);
      if (_closed) {
        await _stop(track);
      }
    }
  }

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
    final aspectRatio = dimensions != null && dimensions.height > 0
        ? dimensions.width / dimensions.height
        : null;

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
      videoAspectRatio: aspectRatio,
      videoTrack: videoPublication?.track,
    );
  }

  static void _log(String message, Object error, StackTrace stackTrace) {
    devLog(
      message,
      name: 'LiveKitRoomDriver',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
