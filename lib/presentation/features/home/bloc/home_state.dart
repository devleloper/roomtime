part of 'home_bloc.dart';

/// Client-side join validation, decided before any request.
enum JoinInputError { invalidCode, notARoomLink }

final class HomeState extends Equatable {
  const HomeState({
    this.recentRooms = const [],
    this.displayName = '',
    this.isLoading = false,
    this.isLookingUp = false,
    this.joinError,
    this.joinFailure,
    this.joinTarget,
    this.isCreating = false,
    this.createFailure,
    this.createdRoom,
  });

  final List<RecentRoom> recentRooms;
  final String displayName;
  final bool isLoading;

  final bool isLookingUp;
  final JoinInputError? joinError;

  /// Lookup failed; cleared by the next edit or submit.
  final Failure? joinFailure;

  /// Lookup succeeded; the screen navigates to the lobby when it changes.
  final RoomSummary? joinTarget;

  final bool isCreating;
  final Failure? createFailure;

  /// Set once per successful create; the sheet shows the invite step.
  final CreatedRoom? createdRoom;

  /// Join errors and [joinTarget] reset on every copy unless given.
  HomeState copyWith({
    List<RecentRoom>? recentRooms,
    String? displayName,
    bool? isLoading,
    bool? isLookingUp,
    JoinInputError? joinError,
    Failure? joinFailure,
    RoomSummary? joinTarget,
    bool? isCreating,
    Failure? createFailure,
    CreatedRoom? createdRoom,
    bool clearCreate = false,
  }) => HomeState(
    recentRooms: recentRooms ?? this.recentRooms,
    displayName: displayName ?? this.displayName,
    isLoading: isLoading ?? this.isLoading,
    isLookingUp: isLookingUp ?? this.isLookingUp,
    joinError: joinError,
    joinFailure: joinFailure,
    joinTarget: joinTarget,
    isCreating: isCreating ?? this.isCreating,
    createFailure: clearCreate ? null : (createFailure ?? this.createFailure),
    createdRoom: clearCreate ? null : (createdRoom ?? this.createdRoom),
  );

  @override
  List<Object?> get props => [
    recentRooms,
    displayName,
    isLoading,
    isLookingUp,
    joinError,
    joinFailure,
    joinTarget,
    isCreating,
    createFailure,
    createdRoom,
  ];
}
