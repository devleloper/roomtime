part of 'home_bloc.dart';

enum JoinInputError { invalidCode, notARoomLink }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<RecentRoom>[]) List<RecentRoom> recentRooms,
    @Default(false) bool isLoading,
    @Default(false) bool isLookingUp,
    JoinInputError? joinError,
    Failure? joinFailure,
    RoomSummary? joinTarget,
    @Default(false) bool isCreating,
    Failure? createFailure,
    CreatedRoom? createdRoom,
  }) = _HomeState;
}
