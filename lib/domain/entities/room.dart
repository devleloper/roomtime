import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roomtime/domain/entities/room_code.dart';

part 'room.freezed.dart';

enum RoomRole { host, participant }

@freezed
abstract class RoomSummary with _$RoomSummary {
  const factory RoomSummary({
    required RoomCode code,
    required Uri inviteUrl,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required bool locked,
    required DateTime expiresAt,
  }) = _RoomSummary;
}

@freezed
abstract class RoomInfo with _$RoomInfo {
  const factory RoomInfo({
    required RoomCode code,
    required Uri inviteUrl,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required bool locked,
    required int maxParticipants,
    required DateTime expiresAt,
  }) = _RoomInfo;
}

@freezed
abstract class CreatedRoom with _$CreatedRoom {
  const factory CreatedRoom({
    required String roomId,
    required RoomCode code,
    required Uri inviteUrl,
    String? name,
    required bool passwordRequired,
    required bool e2ee,
    required int maxParticipants,
    required DateTime expiresAt,
  }) = _CreatedRoom;
}

@freezed
abstract class RoomJoin with _$RoomJoin {
  const RoomJoin._();

  const factory RoomJoin({
    required String token,
    required String livekitUrl,
    required String identity,
    required RoomRole role,
    required RoomInfo room,
  }) = _RoomJoin;

  @override
  String toString() => 'RoomJoin(identity: $identity, role: $role)';
}

@freezed
abstract class CreateRoomParams with _$CreateRoomParams {
  const CreateRoomParams._();

  const factory CreateRoomParams({
    String? name,
    String? password,
    int? maxParticipants,
    int? lifetimeMinutes,
    bool? e2ee,
  }) = _CreateRoomParams;

  @override
  String toString() {
    return 'CreateRoomParams(name: $name, hasPassword: ${password != null})';
  }
}

@Freezed(toStringOverride: false)
sealed class PasswordChange with _$PasswordChange {
  const factory PasswordChange.set(String password) = SetPassword;
  const factory PasswordChange.remove() = RemovePassword;
}

@freezed
abstract class RoomPatch with _$RoomPatch {
  const factory RoomPatch({
    bool? locked,
    String? name,
    PasswordChange? password,
  }) = _RoomPatch;
}

@freezed
abstract class RotatedCode with _$RotatedCode {
  const factory RotatedCode({required RoomCode code, required Uri inviteUrl}) =
      _RotatedCode;
}
