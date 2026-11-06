import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

enum InputField { roomName, password, maxParticipants, lifetime, displayName }

@freezed
sealed class Failure with _$Failure implements Exception {
  const Failure._();

  const factory Failure.roomNotFound() = RoomNotFoundFailure;

  const factory Failure.passwordRequired() = PasswordRequiredFailure;

  const factory Failure.invalidPassword() = InvalidPasswordFailure;

  const factory Failure.roomFull() = RoomFullFailure;

  const factory Failure.roomLocked() = RoomLockedFailure;

  const factory Failure.tooManyAttempts({Duration? retryAfter}) =
      TooManyAttemptsFailure;

  const factory Failure.serverBusy({Duration? retryAfter}) = ServerBusyFailure;

  const factory Failure.invalidCode() = InvalidCodeFailure;

  const factory Failure.forbidden() = ForbiddenFailure;

  const factory Failure.participantBanned() = ParticipantBannedFailure;

  const factory Failure.participantNotFound() = ParticipantNotFoundFailure;

  const factory Failure.invalidInput(InputField field) = InvalidInputFailure;

  const factory Failure.mediaDevice() = MediaDeviceFailure;

  const factory Failure.network() = NetworkFailure;

  const factory Failure.server({int? statusCode}) = ServerFailure;

  const factory Failure.unknown({int? statusCode, String? code}) =
      UnknownFailure;
}
