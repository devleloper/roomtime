import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

part 'room_dtos.freezed.dart';
part 'room_dtos.g.dart';

typedef Json = Map<String, dynamic>;

const _loopbackHosts = {'localhost', '127.0.0.1', '::1'};

class HttpUriConverter implements JsonConverter<Uri, String> {
  const HttpUriConverter();

  @override
  Uri fromJson(String json) {
    final uri = Uri.tryParse(json);
    final isHttp =
        uri != null && (uri.isScheme('https') || uri.isScheme('http'));
    if (isHttp && uri.host.isNotEmpty) {
      return uri;
    }
    throw FormatException('Invalid URL', json);
  }

  @override
  String toJson(Uri object) => object.toString();
}

@freezed
abstract class CreateRoomRequestDto with _$CreateRoomRequestDto {
  const CreateRoomRequestDto._();

  const factory CreateRoomRequestDto({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) String? password,
    @JsonKey(includeIfNull: false) int? maxParticipants,
    @JsonKey(includeIfNull: false) int? lifetimeMinutes,
    @JsonKey(includeIfNull: false) bool? e2ee,
  }) = _CreateRoomRequestDto;

  factory CreateRoomRequestDto.fromParams(CreateRoomParams params) {
    return CreateRoomRequestDto(
      name: params.name,
      password: params.password,
      maxParticipants: params.maxParticipants,
      lifetimeMinutes: params.lifetimeMinutes,
      e2ee: params.e2ee,
    );
  }

  factory CreateRoomRequestDto.fromJson(Json json) =>
      _$CreateRoomRequestDtoFromJson(json);

  @override
  String toString() {
    return 'CreateRoomRequestDto(name: $name, '
        'hasPassword: ${password != null})';
  }
}

@freezed
abstract class CreateRoomResponseDto with _$CreateRoomResponseDto {
  const CreateRoomResponseDto._();

  const factory CreateRoomResponseDto({
    required String roomId,
    @RoomCodeConverter() required RoomCode code,
    @HttpUriConverter() required Uri inviteUrl,
    required String ownerToken,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required int maxParticipants,
    required DateTime expiresAt,
  }) = _CreateRoomResponseDto;

  factory CreateRoomResponseDto.fromJson(Json json) =>
      _$CreateRoomResponseDtoFromJson(json);

  @override
  String toString() => 'CreateRoomResponseDto(roomId: $roomId, code: $code)';

  CreatedRoom get room {
    return CreatedRoom(
      roomId: roomId,
      code: code,
      inviteUrl: inviteUrl,
      name: name,
      passwordRequired: passwordRequired,
      e2ee: e2ee,
      maxParticipants: maxParticipants,
      expiresAt: expiresAt,
    );
  }
}

@freezed
abstract class RoomSummaryDto with _$RoomSummaryDto {
  const RoomSummaryDto._();

  const factory RoomSummaryDto({
    @RoomCodeConverter() required RoomCode code,
    @HttpUriConverter() required Uri inviteUrl,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required bool locked,
    required DateTime expiresAt,
  }) = _RoomSummaryDto;

  factory RoomSummaryDto.fromJson(Json json) => _$RoomSummaryDtoFromJson(json);

  RoomSummary toDomain() {
    return RoomSummary(
      code: code,
      inviteUrl: inviteUrl,
      name: name,
      passwordRequired: passwordRequired,
      e2ee: e2ee,
      locked: locked,
      expiresAt: expiresAt,
    );
  }
}

@freezed
abstract class JoinRequestDto with _$JoinRequestDto {
  const JoinRequestDto._();

  const factory JoinRequestDto({
    required String displayName,
    required String guestId,
    @JsonKey(includeIfNull: false) String? password,
  }) = _JoinRequestDto;

  factory JoinRequestDto.fromJson(Json json) => _$JoinRequestDtoFromJson(json);

  @override
  String toString() {
    return 'JoinRequestDto(displayName: $displayName, '
        'hasPassword: ${password != null})';
  }
}

@freezed
abstract class RoomInfoDto with _$RoomInfoDto {
  const RoomInfoDto._();

  const factory RoomInfoDto({
    @RoomCodeConverter() required RoomCode code,
    @HttpUriConverter() required Uri inviteUrl,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required bool locked,
    required int maxParticipants,
    required DateTime expiresAt,
  }) = _RoomInfoDto;

  factory RoomInfoDto.fromJson(Json json) => _$RoomInfoDtoFromJson(json);

  RoomInfo toDomain() {
    return RoomInfo(
      code: code,
      inviteUrl: inviteUrl,
      name: name,
      passwordRequired: passwordRequired,
      e2ee: e2ee,
      locked: locked,
      maxParticipants: maxParticipants,
      expiresAt: expiresAt,
    );
  }
}

@freezed
abstract class RoomJoinDto with _$RoomJoinDto {
  const RoomJoinDto._();

  const factory RoomJoinDto({
    required String token,
    required String livekitUrl,
    required String identity,
    required RoomRole role,
    required RoomInfoDto room,
  }) = _RoomJoinDto;

  factory RoomJoinDto.fromJson(Json json) => _$RoomJoinDtoFromJson(json);

  @override
  String toString() => 'RoomJoinDto(identity: $identity, role: $role)';

  RoomJoin toDomain({bool requireSecureMedia = kReleaseMode}) {
    final validatedMediaUrl = mediaUrl(
      livekitUrl,
      requireSecure: requireSecureMedia,
    );
    return RoomJoin(
      token: token,
      livekitUrl: validatedMediaUrl,
      identity: identity,
      role: role,
      room: room.toDomain(),
    );
  }
}

@visibleForTesting
String mediaUrl(String raw, {required bool requireSecure}) {
  final uri = Uri.tryParse(raw);
  final secure = uri != null && uri.isScheme('wss') && uri.host.isNotEmpty;
  final plain = uri != null && uri.isScheme('ws') && uri.host.isNotEmpty;
  final loopback = plain && _loopbackHosts.contains(uri.host);
  if (secure || loopback || (plain && !requireSecure)) {
    return raw;
  }
  throw const FormatException('insecure_media_url');
}

Json roomPatchToJson(RoomPatch patch) {
  final json = <String, dynamic>{};
  if (patch.locked != null) {
    json['locked'] = patch.locked;
  }
  if (patch.name != null) {
    json['name'] = patch.name;
  }
  final passwordChange = patch.password;
  if (passwordChange != null) {
    json['password'] = switch (passwordChange) {
      SetPassword(:final password) => password,
      RemovePassword() => null,
    };
  }
  return json;
}

@freezed
abstract class RotatedCodeDto with _$RotatedCodeDto {
  const RotatedCodeDto._();

  const factory RotatedCodeDto({
    @RoomCodeConverter() required RoomCode code,
    @HttpUriConverter() required Uri inviteUrl,
  }) = _RotatedCodeDto;

  factory RotatedCodeDto.fromJson(Json json) => _$RotatedCodeDtoFromJson(json);

  RotatedCode toDomain() {
    return RotatedCode(code: code, inviteUrl: inviteUrl);
  }
}
