import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:permission_handler/permission_handler.dart';
import '../../../../domain/repositories/i_room_repository.dart';
import '../../../../domain/services/i_audio_service.dart';
import 'room_event.dart';
import 'room_state.dart';

@injectable
class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final IRoomRepository _roomRepository;
  final IAudioService _audioService;
  lk.CancelListenFunc? _roomListener;

  RoomBloc(this._roomRepository, this._audioService)
    : super(const RoomState()) {
    on<ConnectToRoom>(_onConnectToRoom);
    on<DisconnectRoom>(_onDisconnectRoom);
    on<ToggleMicrophone>(_onToggleMicrophone);
    on<ToggleCamera>(_onToggleCamera);
    on<SwitchCamera>(_onSwitchCamera);
    on<RoomParticipantsChanged>(_onRoomParticipantsChanged);
    on<ActiveSpeakersChanged>(_onActiveSpeakersChanged);
    on<RoomNotificationReceived>(_onRoomNotificationReceived);
    on<ClearRoomNotification>(_onClearRoomNotification);
    on<AdminEndRoom>(_onAdminEndRoom);
    on<AdminMuteParticipant>(_onAdminMuteParticipant);
  }

  Future<void> _onConnectToRoom(
    ConnectToRoom event,
    Emitter<RoomState> emit,
  ) async {
    emit(state.copyWith(status: RoomStatus.connecting));
    try {
      // 1. Explicitly request permissions on Android/iOS before connecting to LiveKit
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        final cameraStatus = await Permission.camera.request();
        final micStatus = await Permission.microphone.request();

        if (cameraStatus.isDenied || micStatus.isDenied) {
          throw Exception(
            "Camera and Microphone permissions are required to join the room.",
          );
        }
      }

      final data = await _roomRepository.getJoinToken(
        event.roomName,
        event.participantName,
        pin: event.pin,
      );

      final token = data['token'] as String;
      final isOwner = data['isOwner'] as bool;

      // Yield to the event loop to ensure the CircularProgressIndicator
      // gets rendered before the heavy WebRTC connection starts.
      await Future.delayed(const Duration(milliseconds: 100));

      final room = await _roomRepository.connectToRoom(token);

      _roomListener = room.createListener().on<lk.RoomEvent>((roomEvent) {
        if (roomEvent is lk.ParticipantConnectedEvent) {
          _audioService.playJoinSound();
          add(
            const RoomNotificationReceived("A new participant joined the call"),
          );
        } else if (roomEvent is lk.ParticipantDisconnectedEvent) {
          _audioService.playLeaveSound();
          add(const RoomNotificationReceived("A participant left the call"));
        }

        if (roomEvent is lk.ParticipantConnectedEvent ||
            roomEvent is lk.ParticipantDisconnectedEvent ||
            roomEvent is lk.TrackSubscribedEvent ||
            roomEvent is lk.TrackUnsubscribedEvent ||
            roomEvent is lk.TrackMutedEvent ||
            roomEvent is lk.TrackUnmutedEvent ||
            roomEvent is lk.LocalTrackPublishedEvent ||
            roomEvent is lk.LocalTrackUnpublishedEvent) {
          add(
            RoomParticipantsChanged([
              room.localParticipant!,
              ...room.remoteParticipants.values,
            ]),
          );
        } else if (roomEvent is lk.ActiveSpeakersChangedEvent) {
          add(ActiveSpeakersChanged(roomEvent.speakers));
        }
      });

      emit(
        state.copyWith(
          status: RoomStatus.connected,
          room: room,
          isCameraEnabled: true,
          isMicEnabled: true,
          isOwner: isOwner,
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
    emit(state.copyWith(isFrontCamera: !state.isFrontCamera));
    await _roomRepository.switchCamera();
  }

  void _onRoomParticipantsChanged(
    RoomParticipantsChanged event,
    Emitter<RoomState> emit,
  ) {
    emit(
      state.copyWith(
        participants: event.participants,
        updateCount: state.updateCount + 1,
      ),
    );
  }

  void _onActiveSpeakersChanged(
    ActiveSpeakersChanged event,
    Emitter<RoomState> emit,
  ) {
    emit(
      state.copyWith(
        activeSpeakers: event.activeSpeakers,
        updateCount: state.updateCount + 1,
      ),
    );
  }

  void _onRoomNotificationReceived(
    RoomNotificationReceived event,
    Emitter<RoomState> emit,
  ) {
    emit(state.copyWith(notificationMessage: event.message));

    // Auto-clear notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        add(ClearRoomNotification());
      }
    });
  }

  void _onClearRoomNotification(
    ClearRoomNotification event,
    Emitter<RoomState> emit,
  ) {
    emit(state.copyWith(notificationMessage: ""));
  }

  Future<void> _onAdminEndRoom(
    AdminEndRoom event,
    Emitter<RoomState> emit,
  ) async {
    try {
      await _roomRepository.endRoom(event.roomName, event.participantName);
      add(const RoomNotificationReceived("Room ended by Admin"));
    } catch (e) {
      add(RoomNotificationReceived("Failed to end room: $e"));
    }
  }

  Future<void> _onAdminMuteParticipant(
    AdminMuteParticipant event,
    Emitter<RoomState> emit,
  ) async {
    try {
      await _roomRepository.muteParticipant(
        event.roomName,
        event.participantName,
        event.targetId,
        event.trackIdentity,
      );
      add(const RoomNotificationReceived("Participant muted"));
    } catch (e) {
      add(RoomNotificationReceived("Failed to mute participant: $e"));
    }
  }

  @override
  Future<void> close() async {
    if (_roomListener != null) {
      _roomListener!();
    }
    // Ensure data source cleans up token and room reference
    await _roomRepository.disconnectFromRoom();
    return super.close();
  }
}
