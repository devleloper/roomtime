import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/data/models/room_dtos.dart';
import 'package:roomtime/data/network/api_failure_mapper.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';

@lazySingleton
class RoomApiDataSource {
  final Dio _dio;

  RoomApiDataSource(this._dio);

  Future<CreateRoomResponseDto> createRoom(CreateRoomRequestDto request) {
    return _send(
      () => _dio.post<Object?>('/rooms', data: request.toJson()),
      CreateRoomResponseDto.fromJson,
    );
  }

  Future<RoomSummary> lookup(RoomCode code) {
    return _send(
      () => _dio.get<Object?>(_room(code)),
      (json) => RoomSummaryDto.fromJson(json).toDomain(),
    );
  }

  Future<RoomJoin> join(
    RoomCode code,
    JoinRequestDto request, {
    String? ownerToken,
  }) {
    return _send(
      () => _dio.post<Object?>(
        '${_room(code)}/join',
        data: request.toJson(),
        options: _bearer(ownerToken),
      ),
      (json) => RoomJoinDto.fromJson(json).toDomain(),
    );
  }

  Future<void> endRoom(RoomCode code, {required String ownerToken}) {
    return _sendEmpty(
      () => _dio.post<void>('${_room(code)}/end', options: _bearer(ownerToken)),
    );
  }

  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
    required String ownerToken,
  }) {
    return _sendEmpty(
      () => _dio.post<void>(
        '${_participant(code, identity)}/mute',
        data: {'trackSid': trackSid},
        options: _bearer(ownerToken),
      ),
    );
  }

  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    required bool ban,
    required String ownerToken,
  }) {
    return _sendEmpty(
      () => _dio.post<void>(
        '${_participant(code, identity)}/remove',
        data: {'ban': ban},
        options: _bearer(ownerToken),
      ),
    );
  }

  Future<void> updateRoom(
    RoomCode code,
    RoomPatch patch, {
    required String ownerToken,
  }) {
    return _sendEmpty(
      () => _dio.patch<void>(
        _room(code),
        data: roomPatchToJson(patch),
        options: _bearer(ownerToken),
      ),
    );
  }

  Future<RotatedCode> rotateCode(RoomCode code, {required String ownerToken}) {
    return _send(
      () => _dio.post<Object?>(
        '${_room(code)}/rotate-code',
        options: _bearer(ownerToken),
      ),
      (json) => RotatedCodeDto.fromJson(json).toDomain(),
    );
  }

  @visibleForTesting
  static String maskPath(String path) {
    return path
        .replaceFirst(RegExp(r'/rooms/[^/?#]+'), '/rooms/:code')
        .replaceFirst(
          RegExp(r'/participants/[^/?#]+'),
          '/participants/:identity',
        );
  }

  static String _room(RoomCode code) => '/rooms/${code.value}';

  static String _participant(RoomCode code, String identity) {
    return '${_room(code)}/participants/${Uri.encodeComponent(identity)}';
  }

  static Options? _bearer(String? token) {
    if (token == null) {
      return null;
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

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
      if (data is! Json) {
        throw const FormatException('Expected a JSON object');
      }
      return parse(data);
    } on Object catch (error) {
      // FormatException.source may hold the room code or invite URL.
      final reason = error is FormatException
          ? error.message
          : '${error.runtimeType}';
      devLog(
        'Malformed response from ${maskPath(response.requestOptions.path)}: '
        '$reason',
        name: 'RoomApi',
      );
      final errorCode = reason == 'insecure_media_url' ? reason : null;
      throw UnknownFailure(statusCode: response.statusCode, code: errorCode);
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
    devLog(
      '${error.requestOptions.method} ${maskPath(error.requestOptions.path)} '
      'failed: '
      '${error.type.name} ${error.response?.statusCode ?? ''} -> $failure',
      name: 'RoomApi',
    );
    return failure;
  }
}
