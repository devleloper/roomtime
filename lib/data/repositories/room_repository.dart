import 'package:injectable/injectable.dart';

import '../../core/time/clock.dart';
import '../../domain/entities/guest_profile.dart';
import '../../domain/entities/recent_room.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_code.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/i_recent_rooms_repository.dart';
import '../../domain/repositories/i_room_repository.dart';
import '../datasources/owner_token_store.dart';
import '../datasources/room_api_data_source.dart';
import '../models/room_dtos.dart';

@LazySingleton(as: IRoomRepository)
class RoomRepository implements IRoomRepository {
  RoomRepository(this._api, this._ownerTokens, this._recentRooms, this._clock);

  final RoomApiDataSource _api;
  final OwnerTokenStore _ownerTokens;
  final IRecentRoomsRepository _recentRooms;
  final Clock _clock;

  @override
  Future<CreatedRoom> createRoom(CreateRoomParams params) async {
    final response = await _api.createRoom(CreateRoomRequestDto(params));
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
  Future<RoomSummary> lookup(RoomCode code) => _api.lookup(code);

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
  Future<bool> isOwner(RoomCode code) async =>
      await _ownerTokens.findByCode(code.value) != null;

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

  Future<OwnerTokenRecord> _requireOwner(RoomCode code) async =>
      await _ownerTokens.findByCode(code.value) ??
      (throw const ForbiddenFailure());
}
