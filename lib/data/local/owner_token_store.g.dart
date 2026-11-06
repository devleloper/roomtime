// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_token_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerTokenRecord _$OwnerTokenRecordFromJson(Map<String, dynamic> json) =>
    _OwnerTokenRecord(
      roomId: json['roomId'] as String,
      code: json['code'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$OwnerTokenRecordToJson(_OwnerTokenRecord instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'code': instance.code,
      'token': instance.token,
    };
