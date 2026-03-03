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

    final roomOptions = const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultVideoPublishOptions: VideoPublishOptions(
        simulcast: true,
        // ── Bandwidth limits (anti-resource-exhaustion) ──
        videoEncoding: VideoEncoding(
          maxBitrate: 1700000, // 1.7 Mbps cap
          maxFramerate: 30,
        ),
      ),
      defaultCameraCaptureOptions: CameraCaptureOptions(maxFrameRate: 30),
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
    // ── CRITICAL: Clear sensitive state ───────────────────
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
