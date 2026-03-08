import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';
import '../../domain/services/i_audio_service.dart';

@LazySingleton(as: IAudioService)
class AudioService implements IAudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  Future<void> playJoinSound() async {
    try {
      await _player.play(AssetSource('sounds/accept.m4a'));
    } catch (_) {}
  }

  @override
  Future<void> playLeaveSound() async {
    try {
      await _player.play(AssetSource('sounds/exit.m4a'));
    } catch (_) {}
  }
}
