import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomtime/core/utils/dev_log.dart';

@lazySingleton
class CallForegroundService {
  static const _channel = MethodChannel('roomtime/call_foreground_service');

  bool _running = false;

  bool get _supported {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  Future<void> start() async {
    if (!_supported || _running) {
      return;
    }

    _running = true;
    try {
      await [Permission.notification, Permission.bluetoothConnect].request();
      if (!_running) {
        return;
      }
      await _channel.invokeMethod<void>('start');
    } on Exception catch (error, stackTrace) {
      _running = false;
      devLog(
        'Could not start the call foreground service',
        name: 'CallForegroundService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> stop() async {
    if (!_supported || !_running) {
      return;
    }

    _running = false;
    try {
      await _channel.invokeMethod<void>('stop');
    } on Exception catch (error, stackTrace) {
      devLog(
        'Could not stop the call foreground service',
        name: 'CallForegroundService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
