part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

/// Loads the recent rooms and the display name stored on this device.
final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// The join field was submitted: a code in any spelling or an invite link.
final class HomeJoinSubmitted extends HomeEvent {
  const HomeJoinSubmitted(this.input);

  final String input;
}

/// Clears the join error once the user edits the field.
final class HomeJoinInputChanged extends HomeEvent {
  const HomeJoinInputChanged();
}

final class HomeRecentRoomRemoved extends HomeEvent {
  const HomeRecentRoomRemoved(this.code);

  final RoomCode code;
}

/// "Undo" after [HomeRecentRoomRemoved]: puts the entry back in its place.
final class HomeRecentRoomRestored extends HomeEvent {
  const HomeRecentRoomRestored(this.room);

  final RecentRoom room;
}

final class HomeDisplayNameSaved extends HomeEvent {
  const HomeDisplayNameSaved(this.name);

  final String name;
}

/// The create sheet opened: forget the previous result.
final class HomeCreateFormOpened extends HomeEvent {
  const HomeCreateFormOpened();
}

final class HomeCreateRoomRequested extends HomeEvent {
  const HomeCreateRoomRequested(this.params);

  final CreateRoomParams params;
}
