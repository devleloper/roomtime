import 'package:livekit_client/livekit_client.dart';

abstract class IRoomRepository {
  Future<String> getJoinToken(
    String roomName,
    String participantName, {
    String? pin,
  });
  Future<Room> connectToRoom(String token);
  Future<void> disconnectFromRoom();
  Future<void> toggleMicrophone(bool enabled);
  Future<void> toggleCamera(bool enabled);
  Future<void> switchCamera();
}
