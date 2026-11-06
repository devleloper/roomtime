part of 'room_bloc.dart';

@Freezed(toStringOverride: false)
sealed class RoomEvent with _$RoomEvent {
  const factory RoomEvent.joinRequested({
    required RoomCode code,
    String? password,
    @Default(true) bool microphoneEnabled,
    @Default(true) bool cameraEnabled,
    String? displayName,
  }) = RoomJoinRequested;

  const factory RoomEvent.leaveRequested() = RoomLeaveRequested;

  const factory RoomEvent.microphoneToggled(bool enabled) =
      RoomMicrophoneToggled;

  const factory RoomEvent.cameraToggled(bool enabled) = RoomCameraToggled;

  const factory RoomEvent.cameraFlipped() = RoomCameraFlipped;

  const factory RoomEvent.speakerphoneToggled(bool on) =
      RoomSpeakerphoneToggled;

  const factory RoomEvent.audioPlaybackStartRequested() =
      RoomAudioPlaybackStartRequested;

  const factory RoomEvent.appLifecycleChanged(AppLifecycleState state) =
      RoomAppLifecycleChanged;

  const factory RoomEvent.endForAllRequested() = RoomEndForAllRequested;

  const factory RoomEvent.participantMuteRequested({
    required String identity,
    required String trackSid,
  }) = RoomParticipantMuteRequested;

  const factory RoomEvent.participantRemoveRequested({
    required String identity,
    @Default(false) bool ban,
  }) = RoomParticipantRemoveRequested;

  const factory RoomEvent.lockRequested(bool locked) = RoomLockRequested;

  const factory RoomEvent.passwordChangeRequested(String? password) =
      RoomPasswordChangeRequested;

  const factory RoomEvent.inviteRotateRequested() = RoomInviteRotateRequested;

  const factory RoomEvent.expiryWarningDue() = _RoomExpiryWarningDue;

  const factory RoomEvent.callUpdated(CallSnapshot snapshot) = _RoomCallUpdated;
}
