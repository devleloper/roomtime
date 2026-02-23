import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

@injectable
class LiveKitDataSource {
  final Room room = Room();

  Future<Room> connect(String url, String token) async {
    // Setup SVC / Simulcast according to specification
    final connectOptions = const ConnectOptions(
      autoSubscribe: true,
      protocolVersion: ProtocolVersion.v11,
    );

    final roomOptions = const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultVideoPublishOptions: VideoPublishOptions(simulcast: true),
      defaultCameraCaptureOptions: CameraCaptureOptions(
        maxFrameRate: 30, // Optimized
        params: VideoParameters.presetsHD720,
      ),
    );

    await room.connect(
      url,
      token,
      connectOptions: connectOptions,
      roomOptions: roomOptions,
      fastConnectOptions: FastConnectOptions(
        microphone: const TrackOption(enabled: false), // Start muted
        camera: const TrackOption(enabled: true),
      ),
    );
    return room;
  }

  Future<void> disconnect() async {
    await room.disconnect();
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  Future<void> setCameraEnabled(bool enabled) async {
    await room.localParticipant?.setCameraEnabled(enabled);
  }

  Future<void> switchCamera() async {
    final tracks = room.localParticipant?.videoTrackPublications;
    final track =
        tracks?.firstWhere((t) => t.source == TrackSource.camera).track
            as LocalVideoTrack?;
    if (track != null) {
      final mediaStreamTrack = track.mediaStreamTrack;
      // In a real implementation this interacts with hardware, livekit SDK has helper extensions sometimes
      // For now, restarting with another deviceId would serve as switch.
    }
  }
}
