import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/recent_room.dart';
import '../../../../domain/entities/room.dart';
import '../../../../domain/entities/room_code.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/repositories/i_guest_profile_repository.dart';
import '../../../../domain/repositories/i_recent_rooms_repository.dart';
import '../../../../domain/repositories/i_room_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._recentRooms, this._rooms, this._profiles)
    : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeJoinSubmitted>(_onJoin);
    on<HomeJoinInputChanged>(_onJoinInputChanged);
    on<HomeRecentRoomRemoved>(_onRecentRemoved);
    on<HomeRecentRoomRestored>(_onRecentRestored);
    on<HomeDisplayNameSaved>(_onDisplayName);
    on<HomeCreateFormOpened>(_onCreateOpened);
    on<HomeCreateRoomRequested>(_onCreateRoom);
  }

  final IRecentRoomsRepository _recentRooms;
  final IRoomRepository _rooms;
  final IGuestProfileRepository _profiles;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final rooms = await _recentRooms.load();
      final profile = await _profiles.load();
      emit(
        state.copyWith(
          recentRooms: rooms,
          displayName: profile.displayName,
          isLoading: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      developer.log(
        'Home data failed to load',
        name: 'HomeBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Validates on the client first: a malformed code or a foreign link never
  /// reaches the API.
  Future<void> _onJoin(HomeJoinSubmitted event, Emitter<HomeState> emit) async {
    if (state.isLookingUp) return;
    final input = event.input.trim();
    if (input.isEmpty) return;
    final code = RoomCode.tryParse(input);
    if (code == null) {
      emit(
        state.copyWith(
          joinError: _looksLikeLink(input)
              ? JoinInputError.notARoomLink
              : JoinInputError.invalidCode,
        ),
      );
      return;
    }
    emit(state.copyWith(isLookingUp: true));
    try {
      final summary = await _rooms.lookup(code);
      emit(state.copyWith(isLookingUp: false, joinTarget: summary));
    } on Failure catch (failure) {
      emit(state.copyWith(isLookingUp: false, joinFailure: failure));
    }
  }

  static bool _looksLikeLink(String input) =>
      input.contains('://') || input.contains('/');

  void _onJoinInputChanged(
    HomeJoinInputChanged event,
    Emitter<HomeState> emit,
  ) {
    if (state.joinError != null || state.joinFailure != null) {
      emit(state.copyWith());
    }
  }

  Future<void> _onRecentRemoved(
    HomeRecentRoomRemoved event,
    Emitter<HomeState> emit,
  ) => _updateRecent(() => _recentRooms.remove(event.code), emit);

  Future<void> _onRecentRestored(
    HomeRecentRoomRestored event,
    Emitter<HomeState> emit,
  ) => _updateRecent(() => _recentRooms.record(event.room), emit);

  /// Local list only; a storage failure leaves it as it was (CR3-7).
  Future<void> _updateRecent(
    Future<void> Function() change,
    Emitter<HomeState> emit,
  ) async {
    try {
      await change();
      emit(state.copyWith(recentRooms: await _recentRooms.load()));
    } on Failure catch (failure) {
      developer.log('Recent rooms update failed: $failure', name: 'HomeBloc');
    }
  }

  Future<void> _onDisplayName(
    HomeDisplayNameSaved event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final profile = await _profiles.updateDisplayName(event.name);
      emit(state.copyWith(displayName: profile.displayName));
    } on ArgumentError {
      // The dialog validates first; nothing to save.
    }
  }

  void _onCreateOpened(HomeCreateFormOpened event, Emitter<HomeState> emit) =>
      emit(state.copyWith(clearCreate: true));

  Future<void> _onCreateRoom(
    HomeCreateRoomRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isCreating) return;
    emit(state.copyWith(isCreating: true, clearCreate: true));
    try {
      final room = await _rooms.createRoom(event.params);
      emit(
        state.copyWith(
          isCreating: false,
          createdRoom: room,
          recentRooms: await _recentRooms.load(),
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(isCreating: false, createFailure: failure));
    }
  }
}
