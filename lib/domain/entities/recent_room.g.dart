// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentRoom _$RecentRoomFromJson(Map<String, dynamic> json) => _RecentRoom(
  code: const RoomCodeConverter().fromJson(json['code'] as String),
  name: json['name'] as String?,
  role: $enumDecode(_$RoomRoleEnumMap, json['role']),
  lastJoined: DateTime.parse(json['lastJoined'] as String),
);

Map<String, dynamic> _$RecentRoomToJson(_RecentRoom instance) =>
    <String, dynamic>{
      'code': const RoomCodeConverter().toJson(instance.code),
      'name': instance.name,
      'role': _$RoomRoleEnumMap[instance.role]!,
      'lastJoined': _utcIso(instance.lastJoined),
    };

const _$RoomRoleEnumMap = {
  RoomRole.host: 'host',
  RoomRole.participant: 'participant',
};
