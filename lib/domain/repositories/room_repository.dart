import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

abstract interface class RoomRepository {
  Future<CreatedRoom> createRoom(CreateRoomParams params);

  Future<RoomSummary> lookup(RoomCode code);

  Future<RoomJoin> join(
    RoomCode code, {
    required GuestProfile guest,
    String? password,
  });

  Future<bool> isOwner(RoomCode code);

  Future<void> endRoom(RoomCode code);

  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
  });

  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    bool ban = false,
  });

  Future<void> updateRoom(RoomCode code, RoomPatch patch);

  Future<RotatedCode> rotateCode(RoomCode code);
}
