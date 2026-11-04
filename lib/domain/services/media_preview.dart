import 'package:equatable/equatable.dart';

/// Access to one capture device as the lobby sees it.
enum DeviceAccess {
  /// Not known yet (web and macOS ask when the device is first opened).
  unknown,

  /// The OS has not asked yet; show an explainer before [MediaPreview.requestAccess].
  notAsked,
  granted,

  /// Refused by the user or blocked by policy; join is still possible.
  denied,
}

/// Immutable view of the lobby's local preview.
final class MediaPreviewState extends Equatable {
  const MediaPreviewState({
    this.cameraEnabled = false,
    this.microphoneEnabled = false,
    this.cameraStarting = false,
    this.cameraAccess = DeviceAccess.unknown,
    this.microphoneAccess = DeviceAccess.unknown,
    this.videoTrack,
  });

  /// The user's choice; the camera may still be starting or blocked.
  final bool cameraEnabled;
  final bool microphoneEnabled;
  final bool cameraStarting;
  final DeviceAccess cameraAccess;
  final DeviceAccess microphoneAccess;

  /// Opaque handle to the media SDK's local camera track, `null` without
  /// video. Only render widgets downcast it (see `CallParticipant.videoTrack`).
  final Object? videoTrack;

  bool get needsPermissionPrompt =>
      cameraAccess == DeviceAccess.notAsked ||
      microphoneAccess == DeviceAccess.notAsked;

  MediaPreviewState copyWith({
    bool? cameraEnabled,
    bool? microphoneEnabled,
    bool? cameraStarting,
    DeviceAccess? cameraAccess,
    DeviceAccess? microphoneAccess,
    Object? Function()? videoTrack,
  }) => MediaPreviewState(
    cameraEnabled: cameraEnabled ?? this.cameraEnabled,
    microphoneEnabled: microphoneEnabled ?? this.microphoneEnabled,
    cameraStarting: cameraStarting ?? this.cameraStarting,
    cameraAccess: cameraAccess ?? this.cameraAccess,
    microphoneAccess: microphoneAccess ?? this.microphoneAccess,
    videoTrack: videoTrack == null ? this.videoTrack : videoTrack(),
  );

  @override
  List<Object?> get props => [
    cameraEnabled,
    microphoneEnabled,
    cameraStarting,
    cameraAccess,
    microphoneAccess,
    videoTrack,
  ];
}

/// Port to the pre-join camera preview: one instance per lobby.
///
/// The adapter owns the preview camera track and releases it on [release]
/// and [dispose]. The call publishes its own tracks after [release], so the
/// camera is never opened twice at the same time.
abstract interface class MediaPreview {
  /// Emits on every change; does not replay. Read [state] for the current
  /// value.
  Stream<MediaPreviewState> get states;

  MediaPreviewState get state;

  /// Reads permission states and opens the camera when [camera] is on and
  /// access is not pending a prompt. Safe to call again after [release].
  Future<void> start({required bool camera, required bool microphone});

  /// Shows the OS permission prompts (iOS, Android), then starts the camera.
  Future<void> requestAccess();

  /// Reads the permission states again (iOS, Android), e.g. when the app
  /// returns from the system settings, then starts the camera if it may
  /// (CR4-1). A no-op after [release] and where there is no permission query.
  Future<void> refreshAccess();

  Future<void> setCameraEnabled(bool enabled);

  /// Records the choice. The call opens the microphone; where the platform
  /// has no permission query (web, macOS) the adapter only checks access.
  Future<void> setMicrophoneEnabled(bool enabled);

  /// Whether [openSettings] can open the app's permission settings.
  bool get canOpenSettings;

  Future<void> openSettings();

  /// Stops the camera, keeping the choices. No later call opens a device
  /// until [start] runs again. Idempotent.
  Future<void> release();

  /// [release] plus closing [states]. Idempotent.
  Future<void> dispose();
}
