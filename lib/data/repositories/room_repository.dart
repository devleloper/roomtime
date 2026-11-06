import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/clock.dart';
import 'package:roomtime/data/local/owner_token_store.dart';
import 'package:roomtime/data/models/room_dtos.dart';
import 'package:roomtime/data/network/room_api_data_source.dart';
import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/repositories/recent_rooms_repository.dart';
import 'package:roomtime/domain/repositories/room_repository.dart';

@LazySingleton(as: RoomRepository)
class ApiRoomRepository implements RoomRepository {
  final RoomApiDataSource _api;
  final OwnerTokenStore _ownerTokens;
  final RecentRoomsRepository _recentRooms;
  final Clock _clock;

  ApiRoomRepository(
    this._api,
    this._ownerTokens,
    this._recentRooms,
    this._clock,
  );

  @override
  Future<CreatedRoom> createRoom(CreateRoomParams params) async {
    final response = await _api.createRoom(
      CreateRoomRequestDto.fromParams(params),
    );
    final room = response.room;
    await _ownerTokens.save(
      OwnerTokenRecord(
        roomId: room.roomId,
        code: room.code.value,
        token: response.ownerToken,
      ),
    );
    await _recentRooms.record(
      RecentRoom(
        code: room.code,
        name: room.name,
        role: RoomRole.host,
        lastJoined: _clock.now(),
      ),
    );
    return room;
  }

  @override
  Future<RoomSummary> lookup(RoomCode code) {
    return _api.lookup(code);
  }

  @override
  Future<RoomJoin> join(
    RoomCode code, {
    required GuestProfile guest,
    String? password,
  }) async {
    final owner = await _ownerTokens.findByCode(code.value);
    final join = await _api.join(
      code,
      JoinRequestDto(
        displayName: guest.effectiveDisplayName,
        guestId: guest.guestId,
        password: password,
      ),
      ownerToken: owner?.token,
    );
    await _recentRooms.record(
      RecentRoom(
        code: join.room.code,
        name: join.room.name,
        role: join.role,
        lastJoined: _clock.now(),
      ),
    );
    return join;
  }

  @override
  Future<bool> isOwner(RoomCode code) async {
    final owner = await _ownerTokens.findByCode(code.value);
    return owner != null;
  }

  @override
  Future<void> endRoom(RoomCode code) async {
    final owner = await _requireOwner(code);
    await _api.endRoom(code, ownerToken: owner.token);
    await _ownerTokens.delete(owner.roomId);
    await _recentRooms.remove(code);
  }

  @override
  Future<void> muteParticipant(
    RoomCode code, {
    required String identity,
    required String trackSid,
  }) async {
    final owner = await _requireOwner(code);
    await _api.muteParticipant(
      code,
      identity: identity,
      trackSid: trackSid,
      ownerToken: owner.token,
    );
  }

  @override
  Future<void> removeParticipant(
    RoomCode code, {
    required String identity,
    bool ban = false,
  }) async {
    final owner = await _requireOwner(code);
    await _api.removeParticipant(
      code,
      identity: identity,
      ban: ban,
      ownerToken: owner.token,
    );
  }

  @override
  Future<void> updateRoom(RoomCode code, RoomPatch patch) async {
    final owner = await _requireOwner(code);
    await _api.updateRoom(code, patch, ownerToken: owner.token);
  }

  @override
  Future<RotatedCode> rotateCode(RoomCode code) async {
    final owner = await _requireOwner(code);
    final rotated = await _api.rotateCode(code, ownerToken: owner.token);
    await _ownerTokens.save(
      OwnerTokenRecord(
        roomId: owner.roomId,
        code: rotated.code.value,
        token: owner.token,
      ),
    );
    await _recentRooms.replaceCode(code, rotated.code);
    return rotated;
  }

  Future<OwnerTokenRecord> _requireOwner(RoomCode code) async {
    final owner = await _ownerTokens.findByCode(code.value);
    if (owner == null) {
      throw const ForbiddenFailure();
    }
    return owner;
  }
}
