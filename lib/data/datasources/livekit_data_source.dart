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

    await room.connect(
      url,
      token,
      fastConnectOptions: FastConnectOptions(
        microphone: const TrackOption(enabled: true),
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
    final trackPublications = room.localParticipant?.videoTrackPublications;
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
