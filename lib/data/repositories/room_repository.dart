import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../domain/repositories/i_room_repository.dart';
import '../../core/config/env.dart';
import '../datasources/api_data_source.dart';
import '../datasources/livekit_data_source.dart';

@Injectable(as: IRoomRepository)
class RoomRepository implements IRoomRepository {
  final ApiDataSource _apiDataSource;
  final LiveKitDataSource _liveKitDataSource;

  final String liveKitUrl = Env.liveKitUrl;

  RoomRepository(this._apiDataSource, this._liveKitDataSource);

  @override
  Future<String> getJoinToken(
    String roomName,
    String participantName, {
    String? pin,
  }) async {
    return await _apiDataSource.fetchToken(roomName, participantName, pin: pin);
  }

  @override
  Future<Room> connectToRoom(String token) async {
    return _liveKitDataSource.connect(liveKitUrl, token);
  }

  @override
  Future<void> disconnectFromRoom() async {
    await _liveKitDataSource.disconnect();
  }

  @override
  Future<void> toggleMicrophone(bool enabled) async {
    await _liveKitDataSource.setMicrophoneEnabled(enabled);
  }

  @override
  Future<void> toggleCamera(bool enabled) async {
    await _liveKitDataSource.setCameraEnabled(enabled);
  }

  @override
  Future<void> switchCamera() async {
    await _liveKitDataSource.switchCamera();
  }
}
