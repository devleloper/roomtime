import 'dart:io';

import 'package:dio/dio.dart';
import 'package:roomtime/data/datasources/api_failure_mapper.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> problem(int status, String code) => {
  'type': 'about:blank',
  'title': 'Error',
  'status': status,
  'code': code,
};

/// Expected mapping for every `ErrorCode` in docs/api/openapi.yaml.
const specCodes = <String, (int, Failure)>{
  'invalid_request': (400, UnknownFailure(code: 'invalid_request')),
  'unsupported_media_type': (
    415,
    UnknownFailure(code: 'unsupported_media_type'),
  ),
  'payload_too_large': (413, UnknownFailure(code: 'payload_too_large')),
  'invalid_code': (400, InvalidCodeFailure()),
  'invalid_name': (400, InvalidInputFailure(InputField.roomName)),
  'invalid_password_format': (400, InvalidInputFailure(InputField.password)),
  'invalid_max_participants': (
    400,
    InvalidInputFailure(InputField.maxParticipants),
  ),
  'invalid_lifetime': (400, InvalidInputFailure(InputField.lifetime)),
  'invalid_display_name': (400, InvalidInputFailure(InputField.displayName)),
  'invalid_guest_id': (400, UnknownFailure(code: 'invalid_guest_id')),
  'invalid_identity': (400, UnknownFailure(code: 'invalid_identity')),
  'invalid_track_sid': (400, UnknownFailure(code: 'invalid_track_sid')),
  'password_required': (401, PasswordRequiredFailure()),
  'invalid_password': (403, InvalidPasswordFailure()),
  'forbidden': (403, ForbiddenFailure()),
  'participant_banned': (403, ParticipantBannedFailure()),
  'room_not_found': (404, RoomNotFoundFailure()),
  'participant_not_found': (404, ParticipantNotFoundFailure()),
  'track_not_found': (404, ParticipantNotFoundFailure()),
  'not_found': (404, UnknownFailure(code: 'not_found')),
  'method_not_allowed': (405, UnknownFailure(code: 'method_not_allowed')),
  'room_full': (409, RoomFullFailure()),
  'room_locked': (423, RoomLockedFailure()),
  'too_many_attempts': (429, TooManyAttemptsFailure()),
  'rate_limited': (429, TooManyAttemptsFailure()),
  'invalid_signature': (401, UnknownFailure(code: 'invalid_signature')),
  'internal': (500, ServerFailure(statusCode: 500)),
  'store_unavailable': (503, ServerFailure(statusCode: 503)),
  'media_unavailable': (503, ServerFailure(statusCode: 503)),
  'server_busy': (503, ServerBusyFailure()),
};

/// `ErrorCode.enum` from the OpenAPI spec (run from `client/`).
List<String> errorCodesFromSpec() {
  final lines = File('../docs/api/openapi.yaml').readAsLinesSync();
  final start = lines.indexWhere((l) => l.trim() == 'ErrorCode:');
  final codes = <String>[];
  for (final line in lines.skip(start + 3)) {
    final match = RegExp(r'^\s+- ([a-z_]+)$').firstMatch(line);
    if (match == null) break;
    codes.add(match.group(1)!);
  }
  return codes;
}

void main() {
  group('every OpenAPI ErrorCode', () {
    test('the spec and this table list the same codes', () {
      final codes = errorCodesFromSpec();
      expect(codes, hasLength(30));
      expect(codes.toSet(), specCodes.keys.toSet());
    });

    for (final MapEntry(key: code, value: (status, expected))
        in specCodes.entries) {
      test('$status $code -> $expected', () {
        expect(
          failureFromResponse(statusCode: status, body: problem(status, code)),
          expected,
        );
      });
    }
  });

  group('problem+json code', () {
    final cases = <(int, String, Failure)>[
      (404, 'room_not_found', const RoomNotFoundFailure()),
      (401, 'password_required', const PasswordRequiredFailure()),
      (403, 'invalid_password', const InvalidPasswordFailure()),
      (409, 'room_full', const RoomFullFailure()),
      (423, 'room_locked', const RoomLockedFailure()),
      (400, 'invalid_code', const InvalidCodeFailure()),
      (429, 'too_many_attempts', const TooManyAttemptsFailure()),
    ];
    for (final (status, code, expected) in cases) {
      test('$status $code -> ${expected.runtimeType}', () {
        expect(
          failureFromResponse(statusCode: status, body: problem(status, code)),
          expected,
        );
      });
    }

    test('the code wins over the status', () {
      expect(
        failureFromResponse(
          statusCode: 403,
          body: problem(403, 'invalid_password'),
        ),
        const InvalidPasswordFailure(),
      );
    });

    test('429 carries Retry-After seconds', () {
      expect(
        failureFromResponse(
          statusCode: 429,
          body: problem(429, 'too_many_attempts'),
          retryAfterHeader: '30',
        ),
        const TooManyAttemptsFailure(retryAfter: Duration(seconds: 30)),
      );
    });

    test('503 server_busy carries Retry-After, not a lock-out', () {
      expect(
        failureFromResponse(
          statusCode: 503,
          body: problem(503, 'server_busy'),
          retryAfterHeader: '1',
        ),
        const ServerBusyFailure(retryAfter: Duration(seconds: 1)),
      );
    });

    test('an HTTP-date Retry-After is ignored', () {
      expect(
        failureFromResponse(
          statusCode: 429,
          body: null,
          retryAfterHeader: 'Wed, 21 Oct 2026 07:28:00 GMT',
        ),
        const TooManyAttemptsFailure(),
      );
    });
  });

  group('status fallback without a known code', () {
    final cases = <(int, Failure)>[
      (401, const PasswordRequiredFailure()),
      (403, const ForbiddenFailure()),
      (404, const RoomNotFoundFailure()),
      (409, const RoomFullFailure()),
      (423, const RoomLockedFailure()),
      (500, const ServerFailure(statusCode: 500)),
      (503, const ServerFailure(statusCode: 503)),
    ];
    for (final (status, expected) in cases) {
      test('$status -> $expected', () {
        expect(
          failureFromResponse(statusCode: status, body: 'Service Unavailable'),
          expected,
        );
      });
    }

    test('unknown 4xx keeps status and code', () {
      expect(
        failureFromResponse(statusCode: 400, body: problem(400, 'bad_name')),
        const UnknownFailure(statusCode: 400, code: 'bad_name'),
      );
    });
  });

  group('DioException', () {
    final request = RequestOptions(path: '/rooms');

    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
      DioExceptionType.badCertificate,
    ]) {
      test('$type -> NetworkFailure', () {
        expect(
          failureFromDioException(
            DioException(requestOptions: request, type: type),
          ),
          const NetworkFailure(),
        );
      });
    }

    test('badResponse reads the problem document and Retry-After', () {
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: request,
          statusCode: 429,
          data: problem(429, 'too_many_attempts'),
          headers: Headers.fromMap({
            'retry-after': ['5'],
          }),
        ),
      );
      expect(
        failureFromDioException(error),
        const TooManyAttemptsFailure(retryAfter: Duration(seconds: 5)),
      );
    });

    test('cancel and unknown -> UnknownFailure', () {
      for (final type in [DioExceptionType.cancel, DioExceptionType.unknown]) {
        expect(
          failureFromDioException(
            DioException(requestOptions: request, type: type),
          ),
          const UnknownFailure(),
        );
      }
    });
  });
}
