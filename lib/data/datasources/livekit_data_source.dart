import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

@injectable
class LiveKitDataSource {
  Room? _room;

  /// Token is held in-memory ONLY. Never persist LiveKit tokens.
  /// Intentionally set/cleared for secure lifecycle — not read externally.
  // ignore: unused_field
  String? _currentToken;

  Room? get room => _room;

  Future<Room> connect(String url, String token) async {
    // Store token in memory only (for potential reconnect)
    _currentToken = token;

    // Production-grade WebRTC Configuration
    // • H.264: Hardware encoding on mobile (saves CPU/battery over VP8).
    // • Simulcast: Sends multiple resolutions for adaptive client reception.
    // • DegradationPreference: Drops resolution instead of framerate under congestion.
    // • Opus RED & DTX: Redundant packets for loss recovery; silences save bandwidth.
    // • Hardware Audio: AEC, AGC, and noise suppression enabled.

    final roomOptions = RoomOptions(
      adaptiveStream: true,
      dynacast: true,

      // Video: H.264 hardware codec + simulcast
      defaultVideoPublishOptions: const VideoPublishOptions(
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
      defaultAudioPublishOptions: const AudioPublishOptions(
        dtx: true, // save bandwidth during silence
        red: true, // redundant audio data — protects against packet loss
      ),

      // Audio capture: hardware AEC/AGC/NS
      defaultAudioCaptureOptions: const AudioCaptureOptions(
        echoCancellation: true,
        autoGainControl: true,
        noiseSuppression: true,
        highPassFilter: true, // removes low-frequency rumble (AC, traffic)
      ),

      // Camera: 720p @ 30fps from front camera
      defaultCameraCaptureOptions: const CameraCaptureOptions(
        maxFrameRate: 30,
        cameraPosition: CameraPosition.front,
        params: VideoParametersPresets.h720_169,
      ),
    );

    _room = Room(roomOptions: roomOptions);

    await _room!.connect(
      url,
      token,
      fastConnectOptions: FastConnectOptions(
        microphone: const TrackOption(enabled: true),
        camera: const TrackOption(enabled: true),
      ),
    );
    return _room!;
  }

  Future<void> disconnect() async {
    if (_room != null) {
      final participant = _room!.localParticipant;
      if (participant != null) {
        await participant.unpublishAllTracks();
      }
      await _room!.disconnect();
    }
    // CRITICAL: Clear sensitive state
    _currentToken = null;
    _room = null;
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  Future<void> setCameraEnabled(bool enabled) async {
    await _room?.localParticipant?.setCameraEnabled(enabled);
  }

  Future<void> switchCamera() async {
    final trackPublications = _room?.localParticipant?.videoTrackPublications;
    if (trackPublications != null) {
      for (var pub in trackPublications) {
        if (pub.track is LocalVideoTrack) {
          final track = pub.track as LocalVideoTrack;
          final options = track.currentOptions;
          if (options is CameraCaptureOptions) {
            final currentFacing = options.cameraPosition;
            final nextFacing = currentFacing == CameraPosition.front
                ? CameraPosition.back
                : CameraPosition.front;

            await track.restartTrack(
              CameraCaptureOptions(cameraPosition: nextFacing),
            );
          }
        }
      }
    }
  }
}
