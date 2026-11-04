import 'dart:async';

import 'package:roomtime/data/services/livekit_media_preview.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

class FakeTrack implements PreviewTrack {
  FakeTrack(this.id);

  final int id;
  bool stopped = false;

  @override
  Object get handle => this;

  @override
  Future<void> stop() async => stopped = true;
}

/// Devices whose opens the test can hold and fail.
class FakeDevices implements PreviewDevices {
  FakeDevices({this.hasPermissionApi = false});

  @override
  final bool hasPermissionApi;

  final opened = <FakeTrack>[];
  final pendingOpens = <Completer<void>>[];
  bool holdOpens = false;
  Object? openError;
  Object? microphoneError;
  int microphoneProbes = 0;
  Map<Permission, PermissionStatus> statuses = {};
  Map<Permission, PermissionStatus> requestResult = {};

  List<FakeTrack> get live => opened.where((t) => !t.stopped).toList();

  @override
  Future<PreviewTrack> openCamera() async {
    if (holdOpens) {
      final pending = Completer<void>();
      pendingOpens.add(pending);
      await pending.future;
    }
    final error = openError;
    if (error != null) throw error;
    final track = FakeTrack(opened.length);
    opened.add(track);
    return track;
  }

  @override
  Future<void> probeMicrophone() async {
    microphoneProbes++;
    final error = microphoneError;
    if (error != null) throw error;
  }

  @override
  Future<PermissionStatus> status(Permission permission) async =>
      statuses[permission] ?? PermissionStatus.granted;

  @override
  Future<Map<Permission, PermissionStatus>> request(
    List<Permission> permissions,
  ) async => requestResult;

  @override
  Future<void> openSettings() async {}
}

// CR3-2: the preview adapter's sequencing, without a camera.
void main() {
  late FakeDevices devices;
  late LiveKitMediaPreview preview;

  setUp(() {
    devices = FakeDevices();
    preview = LiveKitMediaPreview(devices: devices);
  });

  tearDown(() => preview.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('start opens one camera track and publishes it', () async {
    await preview.start(camera: true, microphone: true);

    expect(devices.live, hasLength(1));
    expect(preview.state.videoTrack, same(devices.live.single));
    expect(preview.state.cameraAccess, DeviceAccess.granted);
    expect(preview.state.cameraStarting, isFalse);
  });

  test('on, off, on while the first open is pending leaves exactly one '
      'live track', () async {
    devices.holdOpens = true;
    final starting = preview.start(camera: true, microphone: false);
    await settle();
    final off = preview.setCameraEnabled(false);
    final on = preview.setCameraEnabled(true);
    await settle();

    devices.pendingOpens.first.complete();
    await settle();
    for (final pending in devices.pendingOpens.skip(1)) {
      pending.complete();
    }
    await Future.wait([starting, off, on]);

    expect(devices.live, hasLength(1));
    expect(preview.state.videoTrack, same(devices.live.single));
  });

  test('off while the open is pending stops the track it returns', () async {
    devices.holdOpens = true;
    final starting = preview.start(camera: true, microphone: false);
    await settle();
    final off = preview.setCameraEnabled(false);

    devices.pendingOpens.single.complete();
    await Future.wait([starting, off]);

    expect(devices.opened.single.stopped, isTrue);
    expect(preview.state.videoTrack, isNull);
    expect(preview.state.cameraStarting, isFalse);
  });

  test('dispose during an open stops the track it returns', () async {
    devices.holdOpens = true;
    final starting = preview.start(camera: true, microphone: false);
    await settle();

    final disposing = preview.dispose();
    devices.pendingOpens.single.complete();
    await starting;
    await disposing;

    expect(devices.opened.single.stopped, isTrue);
    expect(preview.state.videoTrack, isNull);
  });

  // CR3-1: release is sticky until the lobby starts the preview again.
  test('after release nothing reopens the camera until start', () async {
    await preview.start(camera: true, microphone: true);
    await preview.release();
    expect(devices.live, isEmpty);

    await preview.setCameraEnabled(false);
    await preview.setCameraEnabled(true);
    await preview.requestAccess();
    expect(devices.opened, hasLength(1), reason: 'no new track');
    expect(devices.live, isEmpty);

    await preview.start(camera: true, microphone: true);
    expect(devices.live, hasLength(1));
  });

  test('a release while the camera is opening stops that track', () async {
    devices.holdOpens = true;
    final starting = preview.start(camera: true, microphone: false);
    await settle();

    final releasing = preview.release();
    devices.pendingOpens.single.complete();
    await starting;
    await releasing;

    expect(devices.live, isEmpty);
    expect(preview.state.videoTrack, isNull);
  });

  test('a failing camera reads as denied and stops "starting"', () async {
    devices.openError = StateError('NotAllowedError');
    await preview.start(camera: true, microphone: false);

    expect(preview.state.cameraAccess, DeviceAccess.denied);
    expect(preview.state.cameraStarting, isFalse);
    expect(preview.state.videoTrack, isNull);
  });

  group('permission states (iOS, Android)', () {
    setUp(() {
      devices = FakeDevices(hasPermissionApi: true);
      preview = LiveKitMediaPreview(devices: devices);
    });

    test('denied before a request is "not asked": no camera yet', () async {
      devices.statuses = {
        Permission.camera: PermissionStatus.denied,
        Permission.microphone: PermissionStatus.denied,
      };
      await preview.start(camera: true, microphone: true);

      expect(preview.state.cameraAccess, DeviceAccess.notAsked);
      expect(preview.state.microphoneAccess, DeviceAccess.notAsked);
      expect(preview.state.needsPermissionPrompt, isTrue);
      expect(devices.opened, isEmpty);
      expect(devices.microphoneProbes, 0, reason: 'the OS answers here');
    });

    test(
      'denied after a request is a refusal; permanentlyDenied too',
      () async {
        devices
          ..statuses = {Permission.camera: PermissionStatus.denied}
          ..requestResult = {
            Permission.camera: PermissionStatus.denied,
            Permission.microphone: PermissionStatus.permanentlyDenied,
          };
        await preview.start(camera: true, microphone: true);
        await preview.requestAccess();

        expect(preview.state.cameraAccess, DeviceAccess.denied);
        expect(preview.state.microphoneAccess, DeviceAccess.denied);
        expect(devices.opened, isEmpty);
      },
    );

    // CR4-1: access granted in the system settings counts on return.
    test('refreshAccess re-reads a permanent refusal and opens the camera '
        'once', () async {
      devices.statuses = {
        Permission.camera: PermissionStatus.permanentlyDenied,
        Permission.microphone: PermissionStatus.permanentlyDenied,
      };
      await preview.start(camera: true, microphone: true);
      expect(preview.state.cameraAccess, DeviceAccess.denied);

      devices.statuses = {
        Permission.camera: PermissionStatus.granted,
        Permission.microphone: PermissionStatus.granted,
      };
      await preview.refreshAccess();
      await preview.refreshAccess();

      expect(preview.state.cameraAccess, DeviceAccess.granted);
      expect(preview.state.microphoneAccess, DeviceAccess.granted);
      expect(devices.opened, hasLength(1));
    });

    test('granted after a request opens the camera', () async {
      devices
        ..statuses = {Permission.camera: PermissionStatus.denied}
        ..requestResult = {
          Permission.camera: PermissionStatus.granted,
          Permission.microphone: PermissionStatus.limited,
        };
      await preview.start(camera: true, microphone: true);
      await preview.requestAccess();

      expect(preview.state.cameraAccess, DeviceAccess.granted);
      expect(preview.state.microphoneAccess, DeviceAccess.granted);
      expect(devices.live, hasLength(1));
    });
  });

  // UX3-02: web and macOS learn about the microphone in the lobby.
  group('microphone probe (web, macOS)', () {
    test('a refused microphone reads as denied', () async {
      devices.microphoneError = StateError('NotAllowedError');
      await preview.start(camera: false, microphone: true);

      expect(devices.microphoneProbes, 1);
      expect(preview.state.microphoneAccess, DeviceAccess.denied);
    });

    test('a working microphone reads as granted, probed once', () async {
      await preview.start(camera: false, microphone: true);
      await preview.setMicrophoneEnabled(false);
      await preview.setMicrophoneEnabled(true);

      expect(preview.state.microphoneAccess, DeviceAccess.granted);
      expect(devices.microphoneProbes, 1);
    });

    test('muted in the lobby: no probe until turned on', () async {
      await preview.start(camera: false, microphone: false);
      expect(devices.microphoneProbes, 0);

      await preview.setMicrophoneEnabled(true);
      expect(devices.microphoneProbes, 1);
    });

    test('no probe after release', () async {
      await preview.start(camera: false, microphone: false);
      await preview.release();
      await preview.setMicrophoneEnabled(true);
      expect(devices.microphoneProbes, 0);
    });
  });
}
