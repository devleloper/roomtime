import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';

part 'call_session.freezed.dart';

@freezed
abstract class CallConnectOptions with _$CallConnectOptions {
  const CallConnectOptions._();

  const factory CallConnectOptions({
    required String url,
    required String token,
    @Default(true) bool microphoneEnabled,
    @Default(true) bool cameraEnabled,
  }) = _CallConnectOptions;

  @override
  String toString() {
    return 'CallConnectOptions(url: $url, mic: $microphoneEnabled, '
        'camera: $cameraEnabled)';
  }
}

abstract interface class CallSession {
  Stream<CallSnapshot> get snapshots;

  CallSnapshot get snapshot;

  Future<void> connect(CallConnectOptions options);

  Future<void> leave();

  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> setCameraEnabled(bool enabled);

  Future<void> flipCamera();

  bool get canSwitchAudioOutput;

  Future<void> setSpeakerphoneOn(bool on);

  Future<void> startAudio();

  Future<void> dispose();
}
