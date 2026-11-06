import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:permission_handler/permission_handler.dart';
import 'package:roomtime/data/services/livekit_room_options.dart';

abstract interface class PreviewTrack {
  Object get handle;

  Future<void> stop();
}

class PreviewDevices {
  const PreviewDevices();

  bool get hasPermissionApi {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  Future<PreviewTrack> openCamera() async {
    final track = await lk.LocalVideoTrack.createCameraTrack(
      liveKitRoomOptions.defaultCameraCaptureOptions,
    );
    return _LiveKitPreviewTrack(track);
  }

  Future<void> probeMicrophone() async {
    final track = await lk.LocalAudioTrack.create(
      liveKitRoomOptions.defaultAudioCaptureOptions,
    );
    await track.stop();
    await track.dispose();
  }

  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  Future<Map<Permission, PermissionStatus>> request(
    List<Permission> permissions,
  ) {
    return permissions.request();
  }

  Future<void> openSettings() {
    return openAppSettings();
  }
}

class _LiveKitPreviewTrack implements PreviewTrack {
  final lk.LocalVideoTrack _track;

  _LiveKitPreviewTrack(this._track);

  @override
  Object get handle => _track;

  @override
  Future<void> stop() async {
    await _track.stop();
    await _track.dispose();
  }
}
