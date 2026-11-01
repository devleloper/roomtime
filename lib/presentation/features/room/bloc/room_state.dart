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
  final bool isFrontCamera;
  final int updateCount;
  final List<Participant> activeSpeakers;
  final String? notificationMessage;
  final bool isOwner;

  const RoomState({
    this.status = RoomStatus.initial,
    this.room,
    this.participants = const [],
    this.errorMessage,
    this.isMicEnabled = false,
    this.isCameraEnabled = true,
    this.isFrontCamera = true,
    this.updateCount = 0,
    this.activeSpeakers = const [],
    this.notificationMessage,
    this.isOwner = false,
  });

  RoomState copyWith({
    RoomStatus? status,
    Room? room,
    List<Participant>? participants,
    String? errorMessage,
    bool? isMicEnabled,
    bool? isCameraEnabled,
    bool? isFrontCamera,
    int? updateCount,
    List<Participant>? activeSpeakers,
    String? notificationMessage,
    bool? isOwner,
  }) {
    return RoomState(
      status: status ?? this.status,
      room: room ?? this.room,
      participants: participants ?? this.participants,
      errorMessage: errorMessage ?? this.errorMessage,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isCameraEnabled: isCameraEnabled ?? this.isCameraEnabled,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      updateCount: updateCount ?? this.updateCount,
      activeSpeakers: activeSpeakers ?? this.activeSpeakers,
      notificationMessage: notificationMessage ?? this.notificationMessage,
      isOwner: isOwner ?? this.isOwner,
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
    isFrontCamera,
    updateCount,
    activeSpeakers,
    notificationMessage,
    isOwner,
  ];
}
