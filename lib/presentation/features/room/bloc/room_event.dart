import 'package:equatable/equatable.dart';
import 'package:livekit_client/livekit_client.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToRoom extends RoomEvent {
  final String roomName;
  final String participantName;

  const ConnectToRoom({required this.roomName, required this.participantName});

  @override
  List<Object?> get props => [roomName, participantName];
}

class DisconnectRoom extends RoomEvent {}

class ToggleMicrophone extends RoomEvent {
  final bool enabled;
  const ToggleMicrophone(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleCamera extends RoomEvent {
  final bool enabled;
  const ToggleCamera(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class SwitchCamera extends RoomEvent {}

class RoomParticipantsChanged extends RoomEvent {
  final List<Participant> participants;
  const RoomParticipantsChanged(this.participants);

  @override
  List<Object?> get props => [participants];
}

class ActiveSpeakersChanged extends RoomEvent {
  final List<Participant> activeSpeakers;
  const ActiveSpeakersChanged(this.activeSpeakers);

  @override
  List<Object?> get props => [activeSpeakers];
}
