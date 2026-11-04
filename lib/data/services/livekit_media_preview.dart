import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:permission_handler/permission_handler.dart';

import '../../core/log/dev_log.dart';
import '../../domain/services/media_preview.dart';
import '../datasources/livekit_room_options.dart';

/// A camera track opened for the preview. [handle] is what the render widget
/// downcasts (see `MediaPreviewState.videoTrack`).
abstract interface class PreviewTrack {
  Object get handle;

  /// Stops capture and frees the track.
  Future<void> stop();
}

/// Devices and permission APIs behind [LiveKitMediaPreview]. A seam so the
/// adapter's sequencing is testable without a camera (CR3-2); data layer
/// only.
class PreviewDevices {
  const PreviewDevices();

  /// iOS and Android can read the permission state before asking. Web and
  /// macOS cannot: the browser or OS asks when a device is first opened.
  bool get hasPermissionApi =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  Future<PreviewTrack> openCamera() async => _LiveKitPreviewTrack(
    await lk.LocalVideoTrack.createCameraTrack(
      liveKitRoomOptions.defaultCameraCaptureOptions,
    ),
  );

  /// Opens the microphone and closes it again at once, so the browser or OS
  /// prompt shows in the lobby. Throws when access is refused or there is no
  /// microphone.
  Future<void> probeMicrophone() async {
    final track = await lk.LocalAudioTrack.create(
      liveKitRoomOptions.defaultAudioCaptureOptions,
    );
    await track.stop();
    await track.dispose();
  }

  Future<PermissionStatus> status(Permission permission) => permission.status;

  Future<Map<Permission, PermissionStatus>> request(
    List<Permission> permissions,
  ) => permissions.request();

  Future<void> openSettings() => openAppSettings();
}

class _LiveKitPreviewTrack implements PreviewTrack {
  _LiveKitPreviewTrack(this._track);

  final lk.LocalVideoTrack _track;

  @override
  Object get handle => _track;

  @override
  Future<void> stop() async {
    await _track.stop();
    await _track.dispose();
  }
}

/// [MediaPreview] on a LiveKit local camera track. One instance per lobby
/// (registered as factory).
///
/// iOS and Android read the permission state first so the lobby can explain
/// the prompt before the OS shows it. Web and macOS have no such query: the
/// camera prompt shows when the preview opens it, and the microphone is
/// probed (opened and closed) so its prompt and a refusal show in the lobby
/// too, not only after joining (UX3-02).
///
/// [release] is sticky: until the next [start], nothing opens a device again,
/// whatever the lobby still sends while the call is joining (CR3-1).
@Injectable(as: MediaPreview)
class LiveKitMediaPreview implements MediaPreview {
  LiveKitMediaPreview({@ignoreParam PreviewDevices? devices})
    : _devices = devices ?? const PreviewDevices();

  final PreviewDevices _devices;
  final _states = StreamController<MediaPreviewState>.broadcast();
  MediaPreviewState _state = const MediaPreviewState();
  PreviewTrack? _track;
  Future<void> _deviceOp = Future.value();
  bool _released = false;
  bool _disposed = false;

  bool get _active => !_released && !_disposed;

  @override
  Stream<MediaPreviewState> get states => _states.stream;

  @override
  MediaPreviewState get state => _state;

  @override
  bool get canOpenSettings => _devices.hasPermissionApi;

  @override
  Future<void> start({required bool camera, required bool microphone}) async {
    if (_disposed) return;
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
    if (!_active) return;
    if (!_devices.hasPermissionApi) {
      await _probeMicrophone();
      return _syncCamera();
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
    if (!_active || !_devices.hasPermissionApi) return;
    final camera = await _status(Permission.camera);
    final microphone = await _status(Permission.microphone);
    if (!_active) return;
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
    if (enabled && !_devices.hasPermissionApi) await _probeMicrophone();
  }

  @override
  Future<void> openSettings() async {
    if (!_devices.hasPermissionApi) return;
    try {
      await _devices.openSettings();
    } on Object catch (error, stackTrace) {
      _log('could not open settings', error, stackTrace);
    }
  }

  @override
  Future<void> release() {
    _released = true;
    return _serial(_stopTrack);
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await release();
    await _states.close();
  }

  /// Device operations run one at a time, so a quick on/off/on never leaves
  /// an orphaned track and prompts never overlap.
  Future<void> _serial(Future<void> Function() op) =>
      _deviceOp = _deviceOp.then((_) => op());

  /// Web and macOS: finds out once whether the microphone can be opened.
  Future<void> _probeMicrophone() => _serial(() async {
    if (!_active ||
        !_state.microphoneEnabled ||
        _state.microphoneAccess != DeviceAccess.unknown) {
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

  Future<void> _syncCamera() => _serial(() async {
    final wanted =
        _state.cameraEnabled &&
        _active &&
        _state.cameraAccess != DeviceAccess.notAsked &&
        _state.cameraAccess != DeviceAccess.denied;
    if (!wanted) return _stopTrack();
    if (_track != null) return;
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
          videoTrack: () => track.handle,
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

  Future<void> _stopTrack() async {
    final track = _track;
    _track = null;
    if (track != null) await _stop(track);
    _publish(_state.copyWith(videoTrack: () => null));
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
      return _access(await _devices.status(permission));
    } on Object catch (error, stackTrace) {
      _log('permission status failed', error, stackTrace);
      return DeviceAccess.unknown;
    }
  }

  /// A failed read keeps what is known; a re-read "can still ask" does not
  /// undo a refusal the user just gave.
  static DeviceAccess _reread(DeviceAccess current, DeviceAccess read) =>
      switch (read) {
        DeviceAccess.unknown => current,
        DeviceAccess.notAsked when current == DeviceAccess.denied => current,
        _ => read,
      };

  /// `denied` before a request means "can still ask"; after a request it is
  /// a refusal.
  static DeviceAccess _access(PermissionStatus? status, {bool asked = false}) =>
      switch (status) {
        PermissionStatus.granted ||
        PermissionStatus.limited ||
        PermissionStatus.provisional => DeviceAccess.granted,
        PermissionStatus.denied =>
          asked ? DeviceAccess.denied : DeviceAccess.notAsked,
        PermissionStatus.permanentlyDenied ||
        PermissionStatus.restricted => DeviceAccess.denied,
        null => DeviceAccess.unknown,
      };

  void _publish(MediaPreviewState next) {
    if (next == _state) return;
    _state = next;
    if (!_states.isClosed) _states.add(next);
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      devLog(
        message,
        name: 'LiveKitMediaPreview',
        error: error,
        stackTrace: stackTrace,
      );
}
