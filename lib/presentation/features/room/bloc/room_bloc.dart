import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../../domain/repositories/i_room_repository.dart';
import 'room_event.dart';
import 'room_state.dart';

@injectable
class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final IRoomRepository _roomRepository;
  StreamSubscription? _roomListener;

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

      _roomListener = room.createListener().stream.listen((roomEvent) {
        if (roomEvent is ParticipantConnected ||
            roomEvent is ParticipantDisconnected ||
            roomEvent is TrackSubscribed ||
            roomEvent is TrackUnsubscribed) {
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
    await _roomRepository.toggleMicrophone(event.enabled);
    emit(state.copyWith(isMicEnabled: event.enabled));
  }

  Future<void> _onToggleCamera(
    ToggleCamera event,
    Emitter<RoomState> emit,
  ) async {
    await _roomRepository.toggleCamera(event.enabled);
    emit(state.copyWith(isCameraEnabled: event.enabled));
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
    await _roomListener?.cancel();
    if (state.room != null) {
      // Strict memory management
      await state.room!.disconnect();
      state.room!.dispose();
    }
    return super.close();
  }
}
