import 'package:equatable/equatable.dart';

import 'room.dart';
import 'room_code.dart';

/// A room this device created or joined; stored locally only.
final class RecentRoom extends Equatable {
  const RecentRoom({
    required this.code,
    this.name,
    required this.role,
    required this.lastJoined,
  });

  final RoomCode code;
  final String? name;
  final RoomRole role;
  final DateTime lastJoined;

  @override
  List<Object?> get props => [code, name, role, lastJoined];
}
