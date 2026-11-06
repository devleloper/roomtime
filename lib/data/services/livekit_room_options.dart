import 'package:livekit_client/livekit_client.dart';

// H.264 hardware encoding with VP8 fallback, simulcast layers, and Opus DTX/RED.
const liveKitRoomOptions = RoomOptions(
  adaptiveStream: true,
  dynacast: true,

  defaultVideoPublishOptions: VideoPublishOptions(
    videoCodec: 'h264',
    simulcast: true,
    videoEncoding: VideoEncoding(maxBitrate: 1_700_000, maxFramerate: 30),
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
    backupVideoCodec: BackupVideoCodec(
      enabled: true,
      codec: 'vp8',
      simulcast: true,
    ),
    degradationPreference: DegradationPreference.maintainFramerate,
  ),

  defaultAudioPublishOptions: AudioPublishOptions(dtx: true, red: true),

  defaultAudioCaptureOptions: AudioCaptureOptions(
    echoCancellation: true,
    autoGainControl: true,
    noiseSuppression: true,
    highPassFilter: true,
  ),

  defaultCameraCaptureOptions: CameraCaptureOptions(
    maxFrameRate: 30,
    cameraPosition: CameraPosition.front,
    params: VideoParametersPresets.h720_169,
  ),
);
