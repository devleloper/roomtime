import '../entities/call_snapshot.dart';

/// What [CallSession.connect] needs; comes from a `RoomJoin`.
final class CallConnectOptions {
  const CallConnectOptions({
    required this.url,
    required this.token,
    this.microphoneEnabled = true,
    this.cameraEnabled = true,
  });

  final String url;

  /// Short-lived media token; kept in memory only.
  final String token;
  final bool microphoneEnabled;
  final bool cameraEnabled;

  @override
  String toString() =>
      'CallConnectOptions(url: $url, mic: $microphoneEnabled, '
      'camera: $cameraEnabled)';
}

/// Port to the media plane: one instance per call.
///
/// The adapter (LiveKit, in `data/`) owns the media room, its listeners and
/// local tracks and releases them exactly once, on [leave], on a remote
/// disconnect or on [dispose]. Media SDK types never cross this port, with
/// one documented exception: `CallParticipant.videoTrack` is an opaque handle
/// that only render widgets (participant tiles) downcast to the SDK track.
///
/// Commands throw a `Failure` (e.g. `MediaDeviceFailure`, `NetworkFailure`).
abstract interface class CallSession {
  /// Emits on every change; does not replay. Read [snapshot] for the current
  /// value.
  Stream<CallSnapshot> get snapshots;

  CallSnapshot get snapshot;

  /// Connects and publishes the requested tracks. If [leave] or [dispose] is
  /// called meanwhile, the connection is torn down as soon as the attempt
  /// finishes and camera and microphone are released; no failure is thrown.
  Future<void> connect(CallConnectOptions options);

  /// Leaves the call and releases all media. Idempotent.
  Future<void> leave();

  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> setCameraEnabled(bool enabled);

  /// Switches between front and back camera where the device has both.
  Future<void> flipCamera();

  /// Whether the platform can route audio between speaker and earpiece
  /// (iOS/Android).
  bool get canSwitchAudioOutput;

  Future<void> setSpeakerphoneOn(bool on);

  /// Web: resumes audio playback blocked by the browser's autoplay policy.
  /// Must be called from a user gesture.
  Future<void> startAudio();

  /// [leave] plus closing [snapshots]. Idempotent.
  Future<void> dispose();
}
