import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/repositories/recent_rooms_repository.dart';
import 'package:roomtime/domain/repositories/room_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RecentRoomsRepository _recentRooms;
  final RoomRepository _rooms;

  HomeBloc(this._recentRooms, this._rooms) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeJoinSubmitted>(_onJoin);
    on<HomeJoinInputChanged>(_onJoinInputChanged);
    on<HomeRecentRoomRemoved>(_onRecentRemoved);
    on<HomeRecentRoomRestored>(_onRecentRestored);
    on<HomeCreateFormOpened>(_onCreateOpened);
    on<HomeCreateRoomRequested>(_onCreateRoom);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final rooms = await _recentRooms.load();
      emit(state.copyWith(recentRooms: rooms, isLoading: false));
    } on Object catch (error, stackTrace) {
      devLog(
        'Home data failed to load',
        name: 'HomeBloc',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onJoin(HomeJoinSubmitted event, Emitter<HomeState> emit) async {
    if (state.isLookingUp) {
      return;
    }

    final input = event.input.trim();
    if (input.isEmpty) {
      return;
    }

    final code = RoomCode.tryParse(input);
    if (code == null) {
      final joinError = _looksLikeLink(input)
          ? JoinInputError.notARoomLink
          : JoinInputError.invalidCode;
      emit(
        state.copyWith(
          joinError: joinError,
          joinFailure: null,
          joinTarget: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLookingUp: true,
        joinError: null,
        joinFailure: null,
        joinTarget: null,
      ),
    );
    try {
      final summary = await _rooms.lookup(code);
      emit(state.copyWith(isLookingUp: false, joinTarget: summary));
    } on Failure catch (failure) {
      emit(state.copyWith(isLookingUp: false, joinFailure: failure));
    }
  }

  static bool _looksLikeLink(String input) {
    return input.contains('://') || input.contains('/');
  }

  void _onJoinInputChanged(
    HomeJoinInputChanged event,
    Emitter<HomeState> emit,
  ) {
    if (state.joinError != null || state.joinFailure != null) {
      emit(state.copyWith(joinError: null, joinFailure: null));
    }
  }

  Future<void> _onRecentRemoved(
    HomeRecentRoomRemoved event,
    Emitter<HomeState> emit,
  ) {
    return _updateRecent(() => _recentRooms.remove(event.code), emit);
  }

  Future<void> _onRecentRestored(
    HomeRecentRoomRestored event,
    Emitter<HomeState> emit,
  ) {
    return _updateRecent(() => _recentRooms.record(event.room), emit);
  }

  Future<void> _updateRecent(
    Future<void> Function() change,
    Emitter<HomeState> emit,
  ) async {
    try {
      await change();
      final updatedRooms = await _recentRooms.load();
      emit(state.copyWith(recentRooms: updatedRooms));
    } on Failure catch (failure) {
      devLog(
        'Recent rooms update failed: $failure',
        name: 'HomeBloc',
        error: failure,
      );
    }
  }

  void _onCreateOpened(HomeCreateFormOpened event, Emitter<HomeState> emit) {
    emit(state.copyWith(createFailure: null, createdRoom: null));
  }

  Future<void> _onCreateRoom(
    HomeCreateRoomRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isCreating) {
      return;
    }

    emit(
      state.copyWith(isCreating: true, createFailure: null, createdRoom: null),
    );
    try {
      final room = await _rooms.createRoom(event.params);
      final updatedRooms = await _recentRooms.load();
      emit(
        state.copyWith(
          isCreating: false,
          createdRoom: room,
          recentRooms: updatedRooms,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(isCreating: false, createFailure: failure));
    }
  }
}
