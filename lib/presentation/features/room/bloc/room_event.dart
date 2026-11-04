part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => const [];
}

/// Joins [code]; also used to retry from [RoomFailed] (e.g. with a password).
final class RoomJoinRequested extends RoomEvent {
  const RoomJoinRequested({
    required this.code,
    this.password,
    this.microphoneEnabled = true,
    this.cameraEnabled = true,
    this.displayName,
  });

  final RoomCode code;
  final String? password;
  final bool microphoneEnabled;
  final bool cameraEnabled;

  /// Saved to the guest profile before joining; null keeps the stored name.
  final String? displayName;

  @override
  List<Object?> get props => [
    code,
    password,
    microphoneEnabled,
    cameraEnabled,
    displayName,
  ];

  @override
  String toString() =>
      'RoomJoinRequested($code, hasPassword: ${password != null})';
}

final class RoomLeaveRequested extends RoomEvent {
  const RoomLeaveRequested();
}

final class RoomMicrophoneToggled extends RoomEvent {
  const RoomMicrophoneToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class RoomCameraToggled extends RoomEvent {
  const RoomCameraToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class RoomCameraFlipped extends RoomEvent {
  const RoomCameraFlipped();
}

final class RoomSpeakerphoneToggled extends RoomEvent {
  const RoomSpeakerphoneToggled(this.on);

  final bool on;

  @override
  List<Object?> get props => [on];
}

/// Web: user gesture that unblocks audio playback.
final class RoomAudioPlaybackStartRequested extends RoomEvent {
  const RoomAudioPlaybackStartRequested();
}

/// Forwarded by the call screen; pauses the camera in the background on
/// mobile and restores the previous state on resume.
final class RoomAppLifecycleChanged extends RoomEvent {
  const RoomAppLifecycleChanged(this.state);

  final AppLifecycleState state;

  @override
  List<Object?> get props => [state];
}

/// Host: end the call for everyone.
final class RoomEndForAllRequested extends RoomEvent {
  const RoomEndForAllRequested();
}

/// Host: mute one participant's microphone track.
final class RoomParticipantMuteRequested extends RoomEvent {
  const RoomParticipantMuteRequested({
    required this.identity,
    required this.trackSid,
  });

  final String identity;
  final String trackSid;

  @override
  List<Object?> get props => [identity, trackSid];
}

/// Host: remove a participant, optionally banning them from the room.
final class RoomParticipantRemoveRequested extends RoomEvent {
  const RoomParticipantRemoveRequested({
    required this.identity,
    this.ban = false,
  });

  final String identity;
  final bool ban;

  @override
  List<Object?> get props => [identity, ban];
}

/// Host: lock or unlock the room for new joins.
final class RoomLockRequested extends RoomEvent {
  const RoomLockRequested(this.locked);

  final bool locked;

  @override
  List<Object?> get props => [locked];
}

/// Host: set a new password, or remove it with `null`.
final class RoomPasswordChangeRequested extends RoomEvent {
  const RoomPasswordChangeRequested(this.password);

  final String? password;

  @override
  List<Object?> get props => [password != null];

  @override
  String toString() =>
      'RoomPasswordChangeRequested(remove: ${password == null})';
}

/// Host: revoke the invite and issue a new code and link.
final class RoomInviteRotateRequested extends RoomEvent {
  const RoomInviteRotateRequested();
}

final class _RoomExpiryWarningDue extends RoomEvent {
  const _RoomExpiryWarningDue();
}

final class _RoomCallUpdated extends RoomEvent {
  const _RoomCallUpdated(this.snapshot);

  final CallSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}
