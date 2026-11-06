// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateRoomRequestDto _$CreateRoomRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateRoomRequestDto(
  name: json['name'] as String?,
  password: json['password'] as String?,
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  lifetimeMinutes: (json['lifetimeMinutes'] as num?)?.toInt(),
  e2ee: json['e2ee'] as bool?,
);

Map<String, dynamic> _$CreateRoomRequestDtoToJson(
  _CreateRoomRequestDto instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'password': ?instance.password,
  'maxParticipants': ?instance.maxParticipants,
  'lifetimeMinutes': ?instance.lifetimeMinutes,
  'e2ee': ?instance.e2ee,
};

_CreateRoomResponseDto _$CreateRoomResponseDtoFromJson(
  Map<String, dynamic> json,
) => _CreateRoomResponseDto(
  roomId: json['roomId'] as String,
  code: const RoomCodeConverter().fromJson(json['code'] as String),
  inviteUrl: const HttpUriConverter().fromJson(json['inviteUrl'] as String),
  ownerToken: json['ownerToken'] as String,
  name: json['name'] as String?,
  passwordRequired: json['passwordRequired'] as bool,
  e2ee: json['e2ee'] as bool,
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$CreateRoomResponseDtoToJson(
  _CreateRoomResponseDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'code': const RoomCodeConverter().toJson(instance.code),
  'inviteUrl': const HttpUriConverter().toJson(instance.inviteUrl),
  'ownerToken': instance.ownerToken,
  'name': instance.name,
  'passwordRequired': instance.passwordRequired,
  'e2ee': instance.e2ee,
  'maxParticipants': instance.maxParticipants,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

_RoomSummaryDto _$RoomSummaryDtoFromJson(Map<String, dynamic> json) =>
    _RoomSummaryDto(
      code: const RoomCodeConverter().fromJson(json['code'] as String),
      inviteUrl: const HttpUriConverter().fromJson(json['inviteUrl'] as String),
      name: json['name'] as String?,
      passwordRequired: json['passwordRequired'] as bool,
      e2ee: json['e2ee'] as bool,
      locked: json['locked'] as bool,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$RoomSummaryDtoToJson(_RoomSummaryDto instance) =>
    <String, dynamic>{
      'code': const RoomCodeConverter().toJson(instance.code),
      'inviteUrl': const HttpUriConverter().toJson(instance.inviteUrl),
      'name': instance.name,
      'passwordRequired': instance.passwordRequired,
      'e2ee': instance.e2ee,
      'locked': instance.locked,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_JoinRequestDto _$JoinRequestDtoFromJson(Map<String, dynamic> json) =>
    _JoinRequestDto(
      displayName: json['displayName'] as String,
      guestId: json['guestId'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$JoinRequestDtoToJson(_JoinRequestDto instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'guestId': instance.guestId,
      'password': ?instance.password,
    };

_RoomInfoDto _$RoomInfoDtoFromJson(Map<String, dynamic> json) => _RoomInfoDto(
  code: const RoomCodeConverter().fromJson(json['code'] as String),
  inviteUrl: const HttpUriConverter().fromJson(json['inviteUrl'] as String),
  name: json['name'] as String?,
  passwordRequired: json['passwordRequired'] as bool,
  e2ee: json['e2ee'] as bool,
  locked: json['locked'] as bool,
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$RoomInfoDtoToJson(_RoomInfoDto instance) =>
    <String, dynamic>{
      'code': const RoomCodeConverter().toJson(instance.code),
      'inviteUrl': const HttpUriConverter().toJson(instance.inviteUrl),
      'name': instance.name,
      'passwordRequired': instance.passwordRequired,
      'e2ee': instance.e2ee,
      'locked': instance.locked,
      'maxParticipants': instance.maxParticipants,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_RoomJoinDto _$RoomJoinDtoFromJson(Map<String, dynamic> json) => _RoomJoinDto(
  token: json['token'] as String,
  livekitUrl: json['livekitUrl'] as String,
  identity: json['identity'] as String,
  role: $enumDecode(_$RoomRoleEnumMap, json['role']),
  room: RoomInfoDto.fromJson(json['room'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RoomJoinDtoToJson(_RoomJoinDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'livekitUrl': instance.livekitUrl,
      'identity': instance.identity,
      'role': _$RoomRoleEnumMap[instance.role]!,
      'room': instance.room.toJson(),
    };

const _$RoomRoleEnumMap = {
  RoomRole.host: 'host',
  RoomRole.participant: 'participant',
};

_RotatedCodeDto _$RotatedCodeDtoFromJson(Map<String, dynamic> json) =>
    _RotatedCodeDto(
      code: const RoomCodeConverter().fromJson(json['code'] as String),
      inviteUrl: const HttpUriConverter().fromJson(json['inviteUrl'] as String),
    );

Map<String, dynamic> _$RotatedCodeDtoToJson(_RotatedCodeDto instance) =>
    <String, dynamic>{
      'code': const RoomCodeConverter().toJson(instance.code),
      'inviteUrl': const HttpUriConverter().toJson(instance.inviteUrl),
    };
