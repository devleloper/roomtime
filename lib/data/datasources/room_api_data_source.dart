import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../core/log/dev_log.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_code.dart';
import '../../domain/failures/failure.dart';
import '../models/room_dtos.dart';
import 'api_failure_mapper.dart';

/// HTTP client for `/v1/rooms` (ADR-0003). Throws only [Failure].
@lazySingleton
class RoomApiDataSource {
  RoomApiDataSource(this._dio);

  final Dio _dio;

  Future<CreateRoomResponseDto> createRoom(CreateRoomRequestDto request) =>
      _send(
        () => _dio.post<Object?>('/rooms', data: request.toJson()),
        CreateRoomResponseDto.fromJson,
      );

  Future<RoomSummary> lookup(RoomCode code) =>
      _send(() => _dio.get<Object?>(_room(code)), roomSummaryFromJson);

  Future<RoomJoin> join(
    RoomCode code,
    JoinRequestDto request, {
    String? ownerToken,
  }) => _send(
    () => _dio.post<Object?>(
      '${_room(code)}/join',
      data: request.toJson(),
      options: _bearer(ownerToken),
    ),
    roomJoinFromJson,
  );

  Future<void> endRoom(RoomCode code, {required String ownerToken}) =>
      _sendEmpty(
        () =>
            _dio.post<void>('${_room(code)}/end', options: _bearer(ownerToken)),
      );

  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
    required String ownerToken,
  }) => _sendEmpty(
    () => _dio.post<void>(
      '${_participant(code, identity)}/mute',
      data: {'trackSid': trackSid},
      options: _bearer(ownerToken),
    ),
  );

  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    required bool ban,
    required String ownerToken,
  }) => _sendEmpty(
    () => _dio.post<void>(
      '${_participant(code, identity)}/remove',
      data: {'ban': ban},
      options: _bearer(ownerToken),
    ),
  );

  Future<void> updateRoom(
    RoomCode code,
    RoomPatch patch, {
    required String ownerToken,
  }) => _sendEmpty(
    () => _dio.patch<void>(
      _room(code),
      data: roomPatchToJson(patch),
      options: _bearer(ownerToken),
    ),
  );

  Future<RotatedCode> rotateCode(RoomCode code, {required String ownerToken}) =>
      _send(
        () => _dio.post<Object?>(
          '${_room(code)}/rotate-code',
          options: _bearer(ownerToken),
        ),
        rotatedCodeFromJson,
      );

  static String _room(RoomCode code) => '/rooms/${code.value}';

  static String _participant(RoomCode code, String identity) =>
      '${_room(code)}/participants/${Uri.encodeComponent(identity)}';

  static Options? _bearer(String? token) => token == null
      ? null
      : Options(headers: {'Authorization': 'Bearer $token'});

  Future<T> _send<T>(
    Future<Response<Object?>> Function() request,
    T Function(Json json) parse,
  ) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (error) {
      throw _mapped(error);
    }
    final data = response.data;
    try {
      if (data is! Json) throw const FormatException('Expected a JSON object');
      return parse(data);
    } on FormatException catch (error) {
      devLog(
        'Malformed response from ${maskPath(response.requestOptions.path)}: '
        '${error.message}',
        name: 'RoomApi',
      );
      throw UnknownFailure(
        statusCode: response.statusCode,
        code: error.message == 'insecure_media_url' ? error.message : null,
      );
    }
  }

  Future<void> _sendEmpty(Future<Response<void>> Function() request) async {
    try {
      await request();
    } on DioException catch (error) {
      throw _mapped(error);
    }
  }

  Failure _mapped(DioException error) {
    final failure = failureFromDioException(error);
    developer.log(
      '${error.requestOptions.method} ${maskPath(error.requestOptions.path)} '
      'failed: '
      '${error.type.name} ${error.response?.statusCode ?? ''} -> $failure',
      name: 'RoomApi',
    );
    return failure;
  }

  /// The room code grants entry and the identity names a person: neither
  /// goes into logs (SEC-16).
  @visibleForTesting
  static String maskPath(String path) => path
      .replaceFirst(RegExp(r'/rooms/[^/?#]+'), '/rooms/:code')
      .replaceFirst(
        RegExp(r'/participants/[^/?#]+'),
        '/participants/:identity',
      );
}
