import 'package:livekit_client/livekit_client.dart';

abstract class IRoomRepository {
  Future<Map<String, dynamic>> getJoinToken(
    String roomName,
    String participantName, {
    String? pin,
  });
  Future<Room> connectToRoom(String token);
  Future<void> disconnectFromRoom();
  Future<void> toggleMicrophone(bool enabled);
  Future<void> toggleCamera(bool enabled);
  Future<void> switchCamera();
  Future<void> endRoom(String roomName, String participantName);
  Future<void> muteParticipant(String roomName, String participantName, String targetId, String trackIdentity);
}
