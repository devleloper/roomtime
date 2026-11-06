part of 'room_bloc.dart';

sealed class RoomInCall implements RoomState {
  RoomInfo get room;
  RoomRole get role;
  CallSnapshot get call;
  bool get expiresSoon;
}

extension RoomInCallX on RoomInCall {
  Uri get inviteUrl => room.inviteUrl;

  bool get isHost => role == RoomRole.host;
}

@Freezed(copyWith: false)
sealed class RoomState with _$RoomState {
  const factory RoomState.initial() = RoomInitial;

  const factory RoomState.connecting(RoomCode code) = RoomConnecting;

  @Implements<RoomInCall>()
  const factory RoomState.connected({
    required RoomInfo room,
    required RoomRole role,
    required CallSnapshot call,
    @Default(false) bool expiresSoon,
  }) = RoomConnected;

  @Implements<RoomInCall>()
  const factory RoomState.reconnecting({
    required RoomInfo room,
    required RoomRole role,
    required CallSnapshot call,
    @Default(false) bool expiresSoon,
  }) = RoomReconnecting;

  const factory RoomState.ended(
    CallEndReason reason, {
    RoomCode? code,
    @Default(false) bool endedByYou,
  }) = RoomEnded;

  const factory RoomState.failed({
    required RoomCode code,
    required Failure failure,
  }) = RoomFailed;
}

enum RoomSettingsChange {
  locked,
  unlocked,
  passwordSet,
  passwordRemoved,
  inviteRotated;

  static RoomSettingsChange lock(bool isLocked) {
    return isLocked ? locked : unlocked;
  }
}

@freezed
sealed class RoomEffect with _$RoomEffect {
  const factory RoomEffect.participantJoined(CallParticipant participant) =
      ParticipantJoinedEffect;

  const factory RoomEffect.participantLeft(CallParticipant participant) =
      ParticipantLeftEffect;

  const factory RoomEffect.participantMuted(CallParticipant? participant) =
      ParticipantMutedEffect;

  const factory RoomEffect.participantRemoved(CallParticipant? participant) =
      ParticipantRemovedEffect;

  const factory RoomEffect.settingsChanged(RoomSettingsChange change) =
      RoomSettingsChangedEffect;

  const factory RoomEffect.actionFailed(Failure failure) =
      RoomActionFailedEffect;
}
