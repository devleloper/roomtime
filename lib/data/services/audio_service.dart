import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/domain/services/audio_service.dart';

@LazySingleton(as: AudioService)
class AssetAudioService implements AudioService {
  final AudioPlayer _player = AudioPlayer();

  AssetAudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  Future<void> playJoinSound() {
    return _play('sounds/accept.m4a');
  }

  @override
  Future<void> playLeaveSound() {
    return _play('sounds/exit.m4a');
  }

  @override
  @disposeMethod
  Future<void> dispose() {
    return _player.dispose();
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } on Object catch (error) {
      devLog(
        'audio playback unavailable ($assetPath): $error',
        name: 'AssetAudioService',
        error: error,
      );
    }
  }
}
