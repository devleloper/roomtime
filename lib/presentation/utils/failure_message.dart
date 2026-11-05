import '../../domain/failures/failure.dart';
import '../../l10n/l10n.dart';

// User-facing texts for failures (docs/design/flows.md §10). Raw exception
// text is never shown.

extension FailureMessage on Failure {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    RoomNotFoundFailure() => l10n.failureRoomNotFound,
    PasswordRequiredFailure() => l10n.failurePasswordRequired,
    InvalidPasswordFailure() => l10n.failureInvalidPassword,
    RoomFullFailure() => l10n.failureRoomFull,
    RoomLockedFailure() => l10n.failureRoomLocked,
    TooManyAttemptsFailure() => l10n.failureTooManyAttempts,
    ServerBusyFailure() => l10n.failureServerBusy,
    InvalidCodeFailure() => l10n.failureInvalidCode,
    ForbiddenFailure() => l10n.failureForbidden,
    ParticipantBannedFailure() => l10n.failureParticipantBanned,
    ParticipantNotFoundFailure() => l10n.failureParticipantNotFound,
    InvalidInputFailure(:final field) => switch (field) {
      InputField.roomName => l10n.failureInvalidRoomName,
      InputField.password => l10n.failureInvalidPasswordInput,
      InputField.maxParticipants => l10n.failureInvalidMaxParticipants,
      InputField.lifetime => l10n.failureInvalidLifetime,
      InputField.displayName => l10n.failureInvalidDisplayName,
    },
    MediaDeviceFailure() => l10n.failureMediaDevice,
    NetworkFailure() => l10n.failureNetwork,
    ServerFailure() => l10n.failureServer,
    // LiveKit refused the media connection.
    UnknownFailure(code: 'media_refused') => l10n.failureMediaRefused,
    UnknownFailure() => l10n.failureUnknown,
  };
}
