import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import '../../../../domain/repositories/i_room_repository.dart';
import 'room_event.dart';
import 'room_state.dart';

@injectable
class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final IRoomRepository _roomRepository;
  lk.CancelListenFunc? _roomListener;

  RoomBloc(this._roomRepository) : super(const RoomState()) {
    on<ConnectToRoom>(_onConnectToRoom);
    on<DisconnectRoom>(_onDisconnectRoom);
    on<ToggleMicrophone>(_onToggleMicrophone);
    on<ToggleCamera>(_onToggleCamera);
    on<SwitchCamera>(_onSwitchCamera);
    on<RoomParticipantsChanged>(_onRoomParticipantsChanged);
  }

  Future<void> _onConnectToRoom(
    ConnectToRoom event,
    Emitter<RoomState> emit,
  ) async {
    emit(state.copyWith(status: RoomStatus.connecting));
    try {
      final token = await _roomRepository.getJoinToken(
        event.roomName,
        event.participantName,
      );
      final room = await _roomRepository.connectToRoom(token);

      _roomListener = room.createListener().on<lk.RoomEvent>((roomEvent) {
        if (roomEvent is lk.ParticipantConnectedEvent ||
            roomEvent is lk.ParticipantDisconnectedEvent ||
            roomEvent is lk.TrackSubscribedEvent ||
            roomEvent is lk.TrackUnsubscribedEvent) {
          add(
            RoomParticipantsChanged([
              room.localParticipant!,
              ...room.remoteParticipants.values,
            ]),
          );
        }
      });

      emit(
        state.copyWith(
          status: RoomStatus.connected,
          room: room,
          participants: [
            room.localParticipant!,
            ...room.remoteParticipants.values,
          ],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: RoomStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDisconnectRoom(
    DisconnectRoom event,
    Emitter<RoomState> emit,
  ) async {
    await _roomRepository.disconnectFromRoom();
    emit(
      state.copyWith(
        status: RoomStatus.disconnected,
        room: null,
        participants: [],
      ),
    );
  }

  Future<void> _onToggleMicrophone(
    ToggleMicrophone event,
    Emitter<RoomState> emit,
  ) async {
    try {
      await _roomRepository.toggleMicrophone(event.enabled);
      emit(state.copyWith(isMicEnabled: event.enabled));
    } catch (e) {
      emit(
        state.copyWith(
          status: RoomStatus.error,
          errorMessage:
              "Microphone access failed (e.g., Device has no microphone)",
        ),
      );
      emit(
        state.copyWith(status: RoomStatus.connected),
      ); // Reset to connected so UI stays
    }
  }

  Future<void> _onToggleCamera(
    ToggleCamera event,
    Emitter<RoomState> emit,
  ) async {
    try {
      await _roomRepository.toggleCamera(event.enabled);
      emit(state.copyWith(isCameraEnabled: event.enabled));
    } catch (e) {
      emit(
        state.copyWith(
          status: RoomStatus.error,
          errorMessage:
              "Camera access failed (e.g., iOS Simulator has no camera)",
        ),
      );
      emit(
        state.copyWith(status: RoomStatus.connected),
      ); // Reset to connected so UI stays
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<RoomState> emit,
  ) async {
    await _roomRepository.switchCamera();
  }

  void _onRoomParticipantsChanged(
    RoomParticipantsChanged event,
    Emitter<RoomState> emit,
  ) {
    emit(state.copyWith(participants: event.participants));
  }

  @override
  Future<void> close() async {
    if (_roomListener != null) {
      _roomListener!();
    }
    final room = state.room;
    if (room != null) {
      await room.disconnect();
    }
    return super.close();
  }
}
