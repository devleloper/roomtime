import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

@injectable
class LiveKitDataSource {
  late final Room room;

  Future<Room> connect(String url, String token) async {
    // Setup SVC / Simulcast according to specification
    final roomOptions = const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultVideoPublishOptions: VideoPublishOptions(simulcast: true),
      defaultCameraCaptureOptions: CameraCaptureOptions(
        maxFrameRate: 30, // Optimized
      ),
    );

    room = Room(roomOptions: roomOptions);

    await room.connect(url, token);
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
    room.localParticipant?.videoTrackPublications.forEach((pub) async {
      final track = pub.track;
      if (track != null) {
        await track.stop();
      }
    });
    // In a real implementation this interacts with hardware, livekit SDK has helper extensions sometimes
    // For now, restarting with another deviceId would serve as switch.
  }
}
