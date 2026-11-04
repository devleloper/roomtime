import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/room.dart';
import '../../../../domain/entities/room_code.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/repositories/i_guest_profile_repository.dart';
import '../../../../domain/repositories/i_room_repository.dart';
import '../../../../domain/services/media_preview.dart';

enum LobbyStatus { loading, ready, notFound, failed }

final class LobbyState extends Equatable {
  const LobbyState({
    this.status = LobbyStatus.loading,
    this.summary,
    this.isHost = false,
    this.displayName = '',
    this.failure,
    this.preview = const MediaPreviewState(),
  });

  final LobbyStatus status;
  final RoomSummary? summary;

  /// This device holds the owner token: joins as host.
  final bool isHost;

  /// The stored name, used to prefill the name field.
  final String displayName;

  /// Why the lookup failed ([LobbyStatus.failed]).
  final Failure? failure;
  final MediaPreviewState preview;

  LobbyState copyWith({
    LobbyStatus? status,
    RoomSummary? summary,
    bool? isHost,
    String? displayName,
    Failure? failure,
    MediaPreviewState? preview,
  }) => LobbyState(
    status: status ?? this.status,
    summary: summary ?? this.summary,
    isHost: isHost ?? this.isHost,
    displayName: displayName ?? this.displayName,
    failure: failure,
    preview: preview ?? this.preview,
  );

  @override
  List<Object?> get props => [
    status,
    summary,
    isHost,
    displayName,
    failure,
    preview,
  ];
}

/// Pre-join: finds the room, knows whether this device is the host and owns
/// the camera preview. Joining itself is `RoomBloc`'s job; the lobby releases
/// the camera first so it is never opened twice.
@injectable
class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit(this._rooms, this._profiles, this._preview)
    : super(const LobbyState()) {
    _previewSubscription = _preview.states.listen((preview) {
      if (!isClosed) emit(state.copyWith(preview: preview));
    });
  }

  final IRoomRepository _rooms;
  final IGuestProfileRepository _profiles;
  final MediaPreview _preview;
  late final StreamSubscription<MediaPreviewState> _previewSubscription;

  RoomCode? _code;
  bool _camera = true;
  bool _microphone = true;

  bool get canOpenSettings => _preview.canOpenSettings;

  /// Looks the room up (skipped when Home already did) and starts the
  /// preview with the given device choices.
  Future<void> start(
    RoomCode code, {
    RoomSummary? summary,
    bool camera = true,
    bool microphone = true,
  }) async {
    _code = code;
    _camera = camera;
    _microphone = microphone;
    emit(state.copyWith(status: LobbyStatus.loading));
    try {
      final profile = await _profiles.load();
      final isHost = await _rooms.isOwner(code);
      final found = summary ?? await _rooms.lookup(code);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: LobbyStatus.ready,
          summary: found,
          isHost: isHost,
          displayName: profile.displayName,
        ),
      );
    } on RoomNotFoundFailure {
      if (!isClosed) emit(state.copyWith(status: LobbyStatus.notFound));
      return;
    } on InvalidCodeFailure {
      if (!isClosed) emit(state.copyWith(status: LobbyStatus.notFound));
      return;
    } on Failure catch (failure) {
      if (!isClosed) {
        emit(state.copyWith(status: LobbyStatus.failed, failure: failure));
      }
      return;
    } on Object catch (error, stackTrace) {
      developer.log(
        'Lobby lookup failed',
        name: 'LobbyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: LobbyStatus.failed,
            failure: const UnknownFailure(),
          ),
        );
      }
      return;
    }
    await resumeDevices();
  }

  Future<void> retry() async {
    final code = _code;
    if (code == null) return;
    await start(code, camera: _camera, microphone: _microphone);
  }

  Future<void> setCameraEnabled(bool enabled) async {
    _camera = enabled;
    await _preview.setCameraEnabled(enabled);
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    _microphone = enabled;
    await _preview.setMicrophoneEnabled(enabled);
  }

  Future<void> requestAccess() => _preview.requestAccess();

  Future<void> openSettings() => _preview.openSettings();

  /// Re-reads device access, e.g. back from the system settings (CR4-1).
  Future<void> refreshAccess() async {
    if (isClosed) return;
    await _preview.refreshAccess();
  }

  /// Stops the camera before the call opens its own.
  Future<void> releaseDevices() => _preview.release();

  /// Restarts the preview, e.g. after a join failed with a wrong password.
  Future<void> resumeDevices() async {
    if (isClosed) return;
    await _preview.start(camera: _camera, microphone: _microphone);
  }

  @override
  Future<void> close() async {
    await _previewSubscription.cancel();
    await _preview.dispose();
    return super.close();
  }
}
