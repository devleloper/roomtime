import 'package:dio/dio.dart';

import '../../domain/failures/failure.dart';

/// Maps a transport error to a [Failure]. RFC 9457 problem documents are
/// matched by their machine `code` first, then by HTTP status.
Failure failureFromDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final response = error.response;
      if (response == null) return const UnknownFailure();
      return failureFromResponse(
        statusCode: response.statusCode,
        body: response.data,
        retryAfterHeader: response.headers.value('retry-after'),
      );
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const UnknownFailure();
  }
}

/// Maps a non-2xx response. [body] is the decoded problem document (a map),
/// or anything else when the server did not send one.
Failure failureFromResponse({
  required int? statusCode,
  required Object? body,
  String? retryAfterHeader,
}) {
  final code = body is Map ? body['code'] : null;
  final machineCode = code is String ? code : null;

  final byCode = _failureForCode(machineCode, retryAfterHeader);
  if (byCode != null) return byCode;

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

/// Every `ErrorCode` of docs/api/openapi.yaml. Codes that only signal a
/// client bug (malformed request, unknown route, webhook signature) map to
/// [UnknownFailure] with the code kept for logs. `null` for unknown codes,
/// which then fall back to the HTTP status.
Failure? _failureForCode(
  String? code,
  String? retryAfterHeader,
) => switch (code) {
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

/// `Retry-After` in delta-seconds; HTTP-date values are ignored.
Duration? _parseRetryAfter(String? header) {
  final seconds = int.tryParse(header?.trim() ?? '');
  if (seconds == null || seconds < 0) return null;
  return Duration(seconds: seconds);
}
