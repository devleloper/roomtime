import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// Keeps an Android call alive in the background with a foreground service
/// (`CallForegroundService.kt`, types microphone|camera as permitted).
/// No-op on other platforms: iOS keeps audio via `UIBackgroundModes: audio`.
@lazySingleton
class CallForegroundService {
  static const _channel = MethodChannel('roomtime/call_foreground_service');

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool _running = false;

  Future<void> start() async {
    if (!_supported || _running) return;
    _running = true;
    try {
      // Neither blocks the call: without the notification permission the
      // service still runs (its notification is hidden), without Bluetooth
      // the audio stays on the built-in devices.
      await [Permission.notification, Permission.bluetoothConnect].request();
      if (!_running) return;
      await _channel.invokeMethod<void>('start');
    } on Exception catch (error, stackTrace) {
      _running = false;
      developer.log(
        'Could not start the call foreground service',
        name: 'CallForegroundService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> stop() async {
    if (!_supported || !_running) return;
    _running = false;
    try {
      await _channel.invokeMethod<void>('stop');
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Could not stop the call foreground service',
        name: 'CallForegroundService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
