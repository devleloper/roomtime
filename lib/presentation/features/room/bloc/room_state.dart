part of 'room_bloc.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => const [];
}

/// Before the first [RoomJoinRequested].
final class RoomInitial extends RoomState {
  const RoomInitial();
}

/// Joining via the API, then connecting the media session.
final class RoomConnecting extends RoomState {
  const RoomConnecting(this.code);

  final RoomCode code;

  @override
  List<Object?> get props => [code];
}

/// In a call: [RoomConnected] or [RoomReconnecting].
sealed class RoomInCall extends RoomState {
  const RoomInCall({
    required this.room,
    required this.role,
    required this.call,
    this.expiresSoon = false,
  });

  final RoomInfo room;
  final RoomRole role;
  final CallSnapshot call;

  /// Current invite link from the server (changes when the host rotates the
  /// code).
  Uri get inviteUrl => room.inviteUrl;

  /// Host only: the invitation expires within [RoomBloc.expiryWarningLead].
  final bool expiresSoon;

  bool get isHost => role == RoomRole.host;

  @override
  List<Object?> get props => [room, role, call, expiresSoon];
}

final class RoomConnected extends RoomInCall {
  const RoomConnected({
    required super.room,
    required super.role,
    required super.call,
    super.expiresSoon,
  });
}

/// Media connection interrupted; the SDK is trying to restore it.
final class RoomReconnecting extends RoomInCall {
  const RoomReconnecting({
    required super.room,
    required super.role,
    required super.call,
    super.expiresSoon,
  });
}

final class RoomEnded extends RoomState {
  const RoomEnded(this.reason, {this.code, this.endedByYou = false});

  final CallEndReason reason;

  /// The room's latest code (after a rotation), for "Rejoin".
  final RoomCode? code;

  /// The host ended the call for everyone from this device.
  final bool endedByYou;

  @override
  List<Object?> get props => [reason, code, endedByYou];
}

/// Join or connect failed; send [RoomJoinRequested] again to retry
/// (e.g. with a password after [PasswordRequiredFailure]).
final class RoomFailed extends RoomState {
  const RoomFailed({required this.code, required this.failure});

  final RoomCode code;
  final Failure failure;

  @override
  List<Object?> get props => [code, failure];
}

/// One-shot UI effects, delivered through [RoomBloc.effects].
sealed class RoomEffect {
  const RoomEffect();
}

final class ParticipantJoinedEffect extends RoomEffect {
  const ParticipantJoinedEffect(this.participant);

  final CallParticipant participant;
}

final class ParticipantLeftEffect extends RoomEffect {
  const ParticipantLeftEffect(this.participant);

  final CallParticipant participant;
}

/// Host action succeeded on [participant] (null when it already left).
final class ParticipantMutedEffect extends RoomEffect {
  const ParticipantMutedEffect(this.participant);

  final CallParticipant? participant;
}

final class ParticipantRemovedEffect extends RoomEffect {
  const ParticipantRemovedEffect(this.participant);

  final CallParticipant? participant;
}

enum RoomSettingsChange {
  locked,
  unlocked,
  passwordSet,
  passwordRemoved,
  inviteRotated;

  static RoomSettingsChange lock(bool isLocked) => isLocked ? locked : unlocked;
}

/// Host changed a room setting.
final class RoomSettingsChangedEffect extends RoomEffect {
  const RoomSettingsChangedEffect(this.change);

  final RoomSettingsChange change;
}

/// A command (media toggle or host action) failed; the call goes on.
final class RoomActionFailedEffect extends RoomEffect {
  const RoomActionFailedEffect(this.failure);

  final Failure failure;
}
