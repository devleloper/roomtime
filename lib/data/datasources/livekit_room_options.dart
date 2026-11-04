import 'package:livekit_client/livekit_client.dart';

// Production WebRTC configuration (reviewed; keep):
// • H.264: hardware encoding on mobile (saves CPU/battery over VP8).
// • Simulcast: several resolutions for adaptive reception.
// • DegradationPreference: drops resolution instead of framerate.
// • Opus RED & DTX: redundancy against loss; silence saves bandwidth.
// • Hardware audio: AEC, AGC and noise suppression.
const liveKitRoomOptions = RoomOptions(
  adaptiveStream: true,
  dynacast: true,

  // Video: H.264 hardware codec + simulcast
  defaultVideoPublishOptions: VideoPublishOptions(
    videoCodec: 'h264',
    simulcast: true,
    videoEncoding: VideoEncoding(
      maxBitrate: 1_700_000, // 1.7 Mbps — top layer (720p)
      maxFramerate: 30,
    ),
    // Explicit simulcast layers for consistent behavior across devices
    videoSimulcastLayers: [
      VideoParameters(
        dimensions: VideoDimensionsPresets.h180_169,
        encoding: VideoEncoding(maxBitrate: 200_000, maxFramerate: 15),
      ),
      VideoParameters(
        dimensions: VideoDimensionsPresets.h360_169,
        encoding: VideoEncoding(maxBitrate: 600_000, maxFramerate: 25),
      ),
    ],
    // VP8 as fallback for browsers that don't support H.264
    backupVideoCodec: BackupVideoCodec(
      enabled: true,
      codec: 'vp8',
      simulcast: true,
    ),
    // Under congestion: drop resolution, keep framerate smooth
    degradationPreference: DegradationPreference.maintainFramerate,
  ),

  // Audio: Opus with RED + DTX + hardware processing
  defaultAudioPublishOptions: AudioPublishOptions(
    dtx: true, // save bandwidth during silence
    red: true, // redundant audio data — protects against packet loss
  ),

  // Audio capture: hardware AEC/AGC/NS
  defaultAudioCaptureOptions: AudioCaptureOptions(
    echoCancellation: true,
    autoGainControl: true,
    noiseSuppression: true,
    highPassFilter: true, // removes low-frequency rumble (AC, traffic)
  ),

  // Camera: 720p @ 30fps from front camera
  defaultCameraCaptureOptions: CameraCaptureOptions(
    maxFrameRate: 30,
    cameraPosition: CameraPosition.front,
    params: VideoParametersPresets.h720_169,
  ),
);
