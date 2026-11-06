import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/data/services/preview_devices.dart';
import 'package:roomtime/domain/services/media_preview.dart';

@Injectable(as: MediaPreview)
class LiveKitMediaPreview implements MediaPreview {
  final PreviewDevices _devices;
  final _states = StreamController<MediaPreviewState>.broadcast();
  MediaPreviewState _state = const MediaPreviewState();
  PreviewTrack? _track;
  Future<void> _deviceOp = Future.value();
  bool _released = false;
  bool _disposed = false;

  LiveKitMediaPreview({@ignoreParam PreviewDevices? devices})
    : _devices = devices ?? const PreviewDevices();

  bool get _active => !_released && !_disposed;

  @override
  Stream<MediaPreviewState> get states => _states.stream;

  @override
  MediaPreviewState get state => _state;

  @override
  bool get canOpenSettings => _devices.hasPermissionApi;

  @override
  Future<void> start({required bool camera, required bool microphone}) async {
    if (_disposed) {
      return;
    }

    _released = false;
    _publish(
      _state.copyWith(cameraEnabled: camera, microphoneEnabled: microphone),
    );

    if (_devices.hasPermissionApi) {
      final cameraStatus = await _status(Permission.camera);
      final micStatus = await _status(Permission.microphone);
      _publish(
        _state.copyWith(
          cameraAccess: cameraStatus,
          microphoneAccess: micStatus,
        ),
      );
    } else {
      await _probeMicrophone();
    }

    await _syncCamera();
  }

  @override
  Future<void> requestAccess() async {
    if (!_active) {
      return;
    }

    if (!_devices.hasPermissionApi) {
      await _probeMicrophone();
      await _syncCamera();
      return;
    }

    try {
      final result = await _devices.request([
        Permission.camera,
        Permission.microphone,
      ]);
      _publish(
        _state.copyWith(
          cameraAccess: _access(result[Permission.camera], asked: true),
          microphoneAccess: _access(result[Permission.microphone], asked: true),
        ),
      );
    } on Object catch (error, stackTrace) {
      _log('permission request failed', error, stackTrace);
    }

    await _syncCamera();
  }

  @override
  Future<void> refreshAccess() async {
    if (!_active || !_devices.hasPermissionApi) {
      return;
    }

    final camera = await _status(Permission.camera);
    final microphone = await _status(Permission.microphone);
    if (!_active) {
      return;
    }

    _publish(
      _state.copyWith(
        cameraAccess: _reread(_state.cameraAccess, camera),
        microphoneAccess: _reread(_state.microphoneAccess, microphone),
      ),
    );
    await _syncCamera();
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    _publish(_state.copyWith(cameraEnabled: enabled));
    await _syncCamera();
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    _publish(_state.copyWith(microphoneEnabled: enabled));
    if (enabled && !_devices.hasPermissionApi) {
      await _probeMicrophone();
    }
  }

  @override
  Future<void> openSettings() async {
    if (!_devices.hasPermissionApi) {
      return;
    }

    try {
      await _devices.openSettings();
    } on Object catch (error, stackTrace) {
      _log('could not open settings', error, stackTrace);
    }
  }

  @override
  Future<void> release() {
    // Release preview hardware before joining so the call session can open the camera.
    _released = true;
    return _serial(_stopTrack);
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    _disposed = true;
    await release();
    await _states.close();
  }

  Future<void> _serial(Future<void> Function() operation) {
    final nextOperation = _deviceOp.then((_) => operation());
    _deviceOp = nextOperation;
    return nextOperation;
  }

  Future<void> _probeMicrophone() {
    return _serial(() async {
      final shouldProbe =
          _active &&
          _state.microphoneEnabled &&
          _state.microphoneAccess == DeviceAccess.unknown;
      if (!shouldProbe) {
        return;
      }

      try {
        await _devices.probeMicrophone();
        _publish(_state.copyWith(microphoneAccess: DeviceAccess.granted));
      } on Object catch (error, stackTrace) {
        _log('microphone probe failed', error, stackTrace);
        _publish(_state.copyWith(microphoneAccess: DeviceAccess.denied));
      }
    });
  }

  Future<void> _syncCamera() {
    return _serial(() async {
      final canOpenCamera =
          _state.cameraAccess != DeviceAccess.notAsked &&
          _state.cameraAccess != DeviceAccess.denied;
      final wanted = _state.cameraEnabled && _active && canOpenCamera;
      if (!wanted) {
        await _stopTrack();
        return;
      }

      if (_track != null) {
        return;
      }

      _publish(_state.copyWith(cameraStarting: true));
      try {
        final track = await _devices.openCamera();
        if (!_active || !_state.cameraEnabled) {
          await _stop(track);
          _publish(_state.copyWith(cameraStarting: false));
          return;
        }

        _track = track;
        _publish(
          _state.copyWith(
            cameraStarting: false,
            cameraAccess: DeviceAccess.granted,
            videoTrack: track.handle,
          ),
        );
      } on Object catch (error, stackTrace) {
        _log('camera preview failed', error, stackTrace);
        _publish(
          _state.copyWith(
            cameraStarting: false,
            cameraAccess: DeviceAccess.denied,
          ),
        );
      }
    });
  }

  Future<void> _stopTrack() async {
    final track = _track;
    _track = null;
    if (track != null) {
      await _stop(track);
    }
    _publish(_state.copyWith(videoTrack: null));
  }

  Future<void> _stop(PreviewTrack track) async {
    try {
      await track.stop();
    } on Object catch (error, stackTrace) {
      _log('camera stop failed', error, stackTrace);
    }
  }

  Future<DeviceAccess> _status(Permission permission) async {
    try {
      final status = await _devices.status(permission);
      return _access(status);
    } on Object catch (error, stackTrace) {
      _log('permission status failed', error, stackTrace);
      return DeviceAccess.unknown;
    }
  }

  static DeviceAccess _reread(DeviceAccess current, DeviceAccess read) {
    if (read == DeviceAccess.unknown) {
      return current;
    }
    if (read == DeviceAccess.notAsked && current == DeviceAccess.denied) {
      return current;
    }
    return read;
  }

  static DeviceAccess _access(PermissionStatus? status, {bool asked = false}) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return DeviceAccess.granted;
      case PermissionStatus.denied:
        return asked ? DeviceAccess.denied : DeviceAccess.notAsked;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return DeviceAccess.denied;
      case null:
        return DeviceAccess.unknown;
    }
  }

  void _publish(MediaPreviewState next) {
    if (next == _state) {
      return;
    }
    _state = next;
    if (!_states.isClosed) {
      _states.add(next);
    }
  }

  static void _log(String message, Object error, StackTrace stackTrace) {
    devLog(
      message,
      name: 'LiveKitMediaPreview',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
