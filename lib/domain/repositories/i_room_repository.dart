import '../entities/guest_profile.dart';
import '../entities/room.dart';
import '../entities/room_code.dart';

/// Room API (ADR-0003). Every method throws a `Failure` on error.
///
/// Owner tokens are kept by the implementation (secure storage, per roomId)
/// and sent automatically as `Authorization: Bearer` on join and owner calls.
/// Successful create/join/end/rotate also update the local recent rooms.
abstract interface class IRoomRepository {
  Future<CreatedRoom> createRoom(CreateRoomParams params);

  /// Pre-join lookup; unknown, expired and ended codes are `RoomNotFoundFailure`.
  Future<RoomSummary> lookup(RoomCode code);

  Future<RoomJoin> join(
    RoomCode code, {
    required GuestProfile guest,
    String? password,
  });

  /// Whether this device holds the owner token for [code].
  Future<bool> isOwner(RoomCode code);

  /// Owner: ends the call for everyone; the code stops working.
  Future<void> endRoom(RoomCode code);

  /// Owner: mutes one published track of a participant.
  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
  });

  /// Owner: removes a participant; [ban] keeps them out of this room.
  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    bool ban = false,
  });

  /// Owner: lock/unlock, rename, set or remove the password.
  Future<void> updateRoom(RoomCode code, RoomPatch patch);

  /// Owner: revokes the current invitation and returns the new one.
  Future<RotatedCode> rotateCode(RoomCode code);
}
