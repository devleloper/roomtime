import 'package:dio/dio.dart';
import 'package:roomtime/domain/failures/failure.dart';

Failure failureFromDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.badResponse:
      final response = error.response;
      if (response == null) {
        return const UnknownFailure();
      }
      return failureFromResponse(
        statusCode: response.statusCode,
        body: response.data,
        retryAfterHeader: response.headers.value('retry-after'),
      );
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const UnknownFailure();
    // Timeouts, connection and certificate errors, and types added by newer
    // dio versions (e.g. a new timeout kind).
    default:
      return const NetworkFailure();
  }
}

Failure failureFromResponse({
  required int? statusCode,
  required Object? body,
  String? retryAfterHeader,
}) {
  final code = body is Map ? body['code'] : null;
  final machineCode = code is String ? code : null;

  final byCode = _failureForCode(machineCode, retryAfterHeader);
  if (byCode != null) {
    return byCode;
  }

  return switch (statusCode) {
    401 => const PasswordRequiredFailure(),
    403 => const ForbiddenFailure(),
    404 => const RoomNotFoundFailure(),
    409 => const RoomFullFailure(),
    423 => const RoomLockedFailure(),
    429 => TooManyAttemptsFailure(
      retryAfter: _parseRetryAfter(retryAfterHeader),
    ),
    final int status when status >= 500 => ServerFailure(statusCode: status),
    _ => UnknownFailure(statusCode: statusCode, code: machineCode),
  };
}

Failure? _failureForCode(String? code, String? retryAfterHeader) {
  return switch (code) {
    'invalid_code' => const InvalidCodeFailure(),
    'invalid_name' => const InvalidInputFailure(InputField.roomName),
    'invalid_password_format' => const InvalidInputFailure(InputField.password),
    'invalid_max_participants' => const InvalidInputFailure(
      InputField.maxParticipants,
    ),
    'invalid_lifetime' => const InvalidInputFailure(InputField.lifetime),
    'invalid_display_name' => const InvalidInputFailure(InputField.displayName),
    'password_required' => const PasswordRequiredFailure(),
    'invalid_password' => const InvalidPasswordFailure(),
    'forbidden' => const ForbiddenFailure(),
    'participant_banned' => const ParticipantBannedFailure(),
    'room_not_found' => const RoomNotFoundFailure(),
    'participant_not_found' ||
    'track_not_found' => const ParticipantNotFoundFailure(),
    'room_full' => const RoomFullFailure(),
    'room_locked' => const RoomLockedFailure(),
    'too_many_attempts' || 'rate_limited' => TooManyAttemptsFailure(
      retryAfter: _parseRetryAfter(retryAfterHeader),
    ),
    'internal' => const ServerFailure(statusCode: 500),
    'store_unavailable' ||
    'media_unavailable' => const ServerFailure(statusCode: 503),
    'server_busy' => ServerBusyFailure(
      retryAfter: _parseRetryAfter(retryAfterHeader),
    ),
    'invalid_request' ||
    'unsupported_media_type' ||
    'payload_too_large' ||
    'invalid_guest_id' ||
    'invalid_identity' ||
    'invalid_track_sid' ||
    'not_found' ||
    'method_not_allowed' ||
    'invalid_signature' => UnknownFailure(code: code),
    _ => null,
  };
}

Duration? _parseRetryAfter(String? header) {
  final seconds = int.tryParse(header?.trim() ?? '');
  if (seconds == null || seconds < 0) {
    return null;
  }
  return Duration(seconds: seconds);
}
