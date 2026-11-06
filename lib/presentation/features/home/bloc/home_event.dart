part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = HomeStarted;

  const factory HomeEvent.joinSubmitted(String input) = HomeJoinSubmitted;

  const factory HomeEvent.joinInputChanged() = HomeJoinInputChanged;

  const factory HomeEvent.recentRoomRemoved(RoomCode code) =
      HomeRecentRoomRemoved;

  const factory HomeEvent.recentRoomRestored(RecentRoom room) =
      HomeRecentRoomRestored;

  const factory HomeEvent.createFormOpened() = HomeCreateFormOpened;

  const factory HomeEvent.createRoomRequested(CreateRoomParams params) =
      HomeCreateRoomRequested;
}
