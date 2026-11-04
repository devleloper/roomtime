import 'package:equatable/equatable.dart';

/// Every expected error the data layer can report. Repositories and the call
/// session throw a [Failure]; transport exceptions never leave the data layer.
/// The UI maps a failure to a user message; it never shows `toString()`.
sealed class Failure extends Equatable implements Exception {
  const Failure();

  @override
  List<Object?> get props => const [];
}

/// Unknown, expired, ended or revoked code (`404 room_not_found`).
final class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure();
}

/// The room has a password and none was sent (`401 password_required`).
final class PasswordRequiredFailure extends Failure {
  const PasswordRequiredFailure();
}

/// The password was wrong (`403 invalid_password`).
final class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure();
}

/// The room reached `maxParticipants` (`409 room_full`).
final class RoomFullFailure extends Failure {
  const RoomFullFailure();
}

/// The host locked the room (`423 room_locked`).
final class RoomLockedFailure extends Failure {
  const RoomLockedFailure();
}

/// Rate limit or password lock-out (`429`), with the server's `Retry-After`.
final class TooManyAttemptsFailure extends Failure {
  const TooManyAttemptsFailure({this.retryAfter});

  final Duration? retryAfter;

  @override
  List<Object?> get props => [retryAfter];
}

/// The server is at capacity for password checks (`503 server_busy`), with
/// the server's `Retry-After`. Not a lock-out: no attempt was counted, so
/// the user may simply retry.
final class ServerBusyFailure extends Failure {
  const ServerBusyFailure({this.retryAfter});

  final Duration? retryAfter;

  @override
  List<Object?> get props => [retryAfter];
}

/// The code is malformed (`400 invalid_code`, or rejected before any request).
final class InvalidCodeFailure extends Failure {
  const InvalidCodeFailure();
}

/// Owner-only action without a valid owner token (`403 forbidden`).
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure();
}

/// The host banned this guest from the room (`403 participant_banned`).
final class ParticipantBannedFailure extends Failure {
  const ParticipantBannedFailure();
}

/// Host action on a participant or track that is gone
/// (`404 participant_not_found`, `404 track_not_found`).
final class ParticipantNotFoundFailure extends Failure {
  const ParticipantNotFoundFailure();
}

/// User input the server rejected (`400 invalid_name`, ...).
enum InputField { roomName, password, maxParticipants, lifetime, displayName }

final class InvalidInputFailure extends Failure {
  const InvalidInputFailure(this.field);

  final InputField field;

  @override
  List<Object?> get props => [field];
}

/// Camera or microphone unavailable or not permitted.
final class MediaDeviceFailure extends Failure {
  const MediaDeviceFailure();
}

/// No connection, timeout or TLS failure; the request may not have arrived.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// The server failed (`5xx`).
final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

/// Anything not covered above, including malformed responses.
final class UnknownFailure extends Failure {
  const UnknownFailure({this.statusCode, this.code});

  final int? statusCode;

  /// Machine `code` from the problem document, when present.
  final String? code;

  @override
  List<Object?> get props => [statusCode, code];
}
