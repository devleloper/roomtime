import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/repositories/guest_profile_repository.dart';
import 'package:roomtime/domain/repositories/room_repository.dart';
import 'package:roomtime/domain/services/media_preview.dart';

part 'lobby_state.dart';
part 'lobby_cubit.freezed.dart';

@injectable
class LobbyCubit extends Cubit<LobbyState> {
  final RoomRepository _rooms;
  final GuestProfileRepository _profiles;
  final MediaPreview _preview;
  late final StreamSubscription<MediaPreviewState> _previewSubscription;

  RoomCode? _code;
  bool _camera = true;
  bool _microphone = true;

  LobbyCubit(this._rooms, this._profiles, this._preview)
    : super(const LobbyState()) {
    _previewSubscription = _preview.states.listen((preview) {
      if (!isClosed) {
        emit(state.copyWith(preview: preview));
      }
    });
  }

  bool get canOpenSettings {
    return _preview.canOpenSettings;
  }

  Future<void> start(
    RoomCode code, {
    RoomSummary? summary,
    bool camera = true,
    bool microphone = true,
  }) async {
    _code = code;
    _camera = camera;
    _microphone = microphone;
    emit(state.copyWith(status: LobbyStatus.loading, failure: null));
    try {
      final profile = await _profiles.load();
      final isHost = await _rooms.isOwner(code);
      final found = summary ?? await _rooms.lookup(code);
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          status: LobbyStatus.ready,
          summary: found,
          isHost: isHost,
          displayName: profile.displayName,
          failure: null,
        ),
      );
    } on Failure catch (failure) {
      _emitLookupFailure(failure);
      return;
    } on Object catch (error, stackTrace) {
      devLog(
        'Lobby lookup failed',
        name: 'LobbyCubit',
        error: error,
        stackTrace: stackTrace,
      );
      _emitLookupFailure(const UnknownFailure());
      return;
    }
    await resumeDevices();
  }

  void _emitLookupFailure(Failure failure) {
    if (isClosed) {
      return;
    }
    if (failure is RoomNotFoundFailure || failure is InvalidCodeFailure) {
      emit(state.copyWith(status: LobbyStatus.notFound, failure: null));
    } else {
      emit(state.copyWith(status: LobbyStatus.failed, failure: failure));
    }
  }

  Future<void> retry() async {
    final code = _code;
    if (code == null) {
      return;
    }
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

  Future<void> requestAccess() {
    return _preview.requestAccess();
  }

  Future<void> openSettings() {
    return _preview.openSettings();
  }

  Future<void> refreshAccess() async {
    if (isClosed) {
      return;
    }
    await _preview.refreshAccess();
  }

  Future<void> releaseDevices() {
    return _preview.release();
  }

  Future<void> resumeDevices() async {
    if (isClosed) {
      return;
    }
    await _preview.start(camera: _camera, microphone: _microphone);
  }

  @override
  Future<void> close() async {
    await _previewSubscription.cancel();
    await _preview.dispose();
    return super.close();
  }
}
