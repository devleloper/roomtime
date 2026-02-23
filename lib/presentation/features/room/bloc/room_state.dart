import 'package:equatable/equatable.dart';
import 'package:livekit_client/livekit_client.dart';

enum RoomStatus { initial, connecting, connected, error, disconnected }

class RoomState extends Equatable {
  final RoomStatus status;
  final Room? room;
  final List<Participant> participants;
  final String? errorMessage;
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final int updateCount;

  const RoomState({
    this.status = RoomStatus.initial,
    this.room,
    this.participants = const [],
    this.errorMessage,
    this.isMicEnabled = false,
    this.isCameraEnabled = true,
    this.updateCount = 0,
  });

  RoomState copyWith({
    RoomStatus? status,
    Room? room,
    List<Participant>? participants,
    String? errorMessage,
    bool? isMicEnabled,
    bool? isCameraEnabled,
    int? updateCount,
  }) {
    return RoomState(
      status: status ?? this.status,
      room: room ?? this.room,
      participants: participants ?? this.participants,
      errorMessage: errorMessage ?? this.errorMessage,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isCameraEnabled: isCameraEnabled ?? this.isCameraEnabled,
      updateCount: updateCount ?? this.updateCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    room,
    participants,
    errorMessage,
    isMicEnabled,
    isCameraEnabled,
    updateCount,
  ];
}
