part of 'lobby_cubit.dart';

enum LobbyStatus { loading, ready, notFound, failed }

@freezed
abstract class LobbyState with _$LobbyState {
  const factory LobbyState({
    @Default(LobbyStatus.loading) LobbyStatus status,
    RoomSummary? summary,
    @Default(false) bool isHost,
    @Default('') String displayName,
    Failure? failure,
    @Default(MediaPreviewState()) MediaPreviewState preview,
  }) = _LobbyState;
}
