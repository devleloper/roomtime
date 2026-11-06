import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_snapshot.freezed.dart';

enum CallConnection { idle, connecting, connected, reconnecting, disconnected }

enum CallEndReason {
  left,
  endedByHost,
  removed,
  roomDeleted,
  joinedElsewhere,
  connectionLost,
}

@freezed
abstract class CallParticipant with _$CallParticipant {
  const factory CallParticipant({
    required String id,
    required String identity,
    required String displayName,
    required bool isLocal,
    @Default(false) bool isSpeaking,
    @Default(false) bool microphoneEnabled,
    @Default(false) bool cameraEnabled,
    @Default(false) bool weakConnection,
    String? audioTrackSid,
    double? videoAspectRatio,
    Object? videoTrack,
  }) = _CallParticipant;
}

@freezed
abstract class CallSnapshot with _$CallSnapshot {
  const CallSnapshot._();

  const factory CallSnapshot({
    @Default(CallConnection.idle) CallConnection connection,
    CallEndReason? endReason,
    @Default(<CallParticipant>[]) List<CallParticipant> participants,
    @Default(false) bool microphoneEnabled,
    @Default(false) bool cameraEnabled,
    @Default(true) bool frontCamera,
    @Default(false) bool speakerphoneOn,
    @Default(false) bool audioPlaybackBlocked,
    @Default(false) bool microphoneUnavailable,
  }) = _CallSnapshot;

  CallParticipant? get local {
    for (final participant in participants) {
      if (participant.isLocal) {
        return participant;
      }
    }
    return null;
  }

  Iterable<CallParticipant> get remote {
    return participants.where((participant) => !participant.isLocal);
  }
}
