import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

part 'recent_room.freezed.dart';
part 'recent_room.g.dart';

@freezed
abstract class RecentRoom with _$RecentRoom {
  const factory RecentRoom({
    @RoomCodeConverter() required RoomCode code,
    String? name,
    required RoomRole role,
    @JsonKey(toJson: _utcIso) required DateTime lastJoined,
  }) = _RecentRoom;

  factory RecentRoom.fromJson(Map<String, dynamic> json) =>
      _$RecentRoomFromJson(json);
}

String _utcIso(DateTime value) => value.toUtc().toIso8601String();
