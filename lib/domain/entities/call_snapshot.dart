import 'package:equatable/equatable.dart';

enum CallConnection { idle, connecting, connected, reconnecting, disconnected }

/// Why a call ended.
enum CallEndReason {
  /// This device left.
  left,

  /// The host ended the room for everyone.
  endedByHost,

  /// The host removed this participant.
  removed,

  /// The media room was deleted (e.g. it expired).
  roomDeleted,

  /// The same guest joined from another device or tab.
  joinedElsewhere,

  /// The connection dropped and could not be restored.
  connectionLost,
}

/// One participant as the call UI sees it.
final class CallParticipant extends Equatable {
  const CallParticipant({
    required this.id,
    required this.identity,
    required this.displayName,
    required this.isLocal,
    this.isSpeaking = false,
    this.microphoneEnabled = false,
    this.cameraEnabled = false,
    this.weakConnection = false,
    this.audioTrackSid,
    this.videoAspectRatio,
    this.videoTrack,
  });

  /// Session id, stable for the lifetime of this participant's connection.
  final String id;

  /// Server-assigned identity; the target of owner actions.
  final String identity;
  final String displayName;
  final bool isLocal;
  final bool isSpeaking;
  final bool microphoneEnabled;
  final bool cameraEnabled;

  /// The media server rates this participant's connection as poor or lost,
  /// so their audio or video may stall (UX3-14).
  final bool weakConnection;

  /// Published microphone track, for owner mute.
  final String? audioTrackSid;

  /// Width / height of the camera video, when known.
  final double? videoAspectRatio;

  /// Opaque handle to the media SDK's video track, `null` without video.
  ///
  /// Only render widgets (participant tiles) may downcast it to the SDK type;
  /// see the "media render exception" in the architecture notes of
  /// `CallSession`.
  final Object? videoTrack;

  @override
  List<Object?> get props => [
    id,
    identity,
    displayName,
    isLocal,
    isSpeaking,
    microphoneEnabled,
    cameraEnabled,
    weakConnection,
    audioTrackSid,
    videoAspectRatio,
    videoTrack,
  ];
}

/// Immutable view of a call at one moment.
final class CallSnapshot extends Equatable {
  const CallSnapshot({
    this.connection = CallConnection.idle,
    this.endReason,
    this.participants = const [],
    this.microphoneEnabled = false,
    this.cameraEnabled = false,
    this.frontCamera = true,
    this.speakerphoneOn = false,
    this.audioPlaybackBlocked = false,
    this.microphoneUnavailable = false,
  });

  final CallConnection connection;

  /// Set when [connection] is [CallConnection.disconnected].
  final CallEndReason? endReason;

  /// Local participant first, then remote participants.
  final List<CallParticipant> participants;
  final bool microphoneEnabled;
  final bool cameraEnabled;
  final bool frontCamera;
  final bool speakerphoneOn;

  /// Web: the browser blocked audio playback until a user gesture; call
  /// `CallSession.startAudio` from a tap.
  final bool audioPlaybackBlocked;

  /// The microphone was asked for (at join or by a toggle) but could not be
  /// opened: blocked, busy or missing. Others cannot hear this participant
  /// until a later attempt succeeds (UX3-02).
  final bool microphoneUnavailable;

  CallParticipant? get local {
    for (final p in participants) {
      if (p.isLocal) return p;
    }
    return null;
  }

  Iterable<CallParticipant> get remote => participants.where((p) => !p.isLocal);

  CallSnapshot copyWith({
    CallConnection? connection,
    CallEndReason? endReason,
    List<CallParticipant>? participants,
    bool? microphoneEnabled,
    bool? cameraEnabled,
    bool? frontCamera,
    bool? speakerphoneOn,
    bool? audioPlaybackBlocked,
    bool? microphoneUnavailable,
  }) => CallSnapshot(
    connection: connection ?? this.connection,
    endReason: endReason ?? this.endReason,
    participants: participants ?? this.participants,
    microphoneEnabled: microphoneEnabled ?? this.microphoneEnabled,
    cameraEnabled: cameraEnabled ?? this.cameraEnabled,
    frontCamera: frontCamera ?? this.frontCamera,
    speakerphoneOn: speakerphoneOn ?? this.speakerphoneOn,
    audioPlaybackBlocked: audioPlaybackBlocked ?? this.audioPlaybackBlocked,
    microphoneUnavailable: microphoneUnavailable ?? this.microphoneUnavailable,
  );

  @override
  List<Object?> get props => [
    connection,
    endReason,
    participants,
    microphoneEnabled,
    cameraEnabled,
    frontCamera,
    speakerphoneOn,
    audioPlaybackBlocked,
    microphoneUnavailable,
  ];
}
