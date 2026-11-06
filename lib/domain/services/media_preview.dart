import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_preview.freezed.dart';

enum DeviceAccess { unknown, notAsked, granted, denied }

@freezed
abstract class MediaPreviewState with _$MediaPreviewState {
  const MediaPreviewState._();

  const factory MediaPreviewState({
    @Default(false) bool cameraEnabled,
    @Default(false) bool microphoneEnabled,
    @Default(false) bool cameraStarting,
    @Default(DeviceAccess.unknown) DeviceAccess cameraAccess,
    @Default(DeviceAccess.unknown) DeviceAccess microphoneAccess,
    Object? videoTrack,
  }) = _MediaPreviewState;

  bool get needsPermissionPrompt {
    return cameraAccess == DeviceAccess.notAsked ||
        microphoneAccess == DeviceAccess.notAsked;
  }
}

abstract interface class MediaPreview {
  Stream<MediaPreviewState> get states;

  MediaPreviewState get state;

  Future<void> start({required bool camera, required bool microphone});

  Future<void> requestAccess();

  Future<void> refreshAccess();

  Future<void> setCameraEnabled(bool enabled);

  Future<void> setMicrophoneEnabled(bool enabled);

  bool get canOpenSettings;

  Future<void> openSettings();

  Future<void> release();

  Future<void> dispose();
}
