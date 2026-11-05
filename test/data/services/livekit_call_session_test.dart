import 'dart:async';

import 'package:roomtime/data/services/call_foreground_service.dart';
import 'package:roomtime/data/services/livekit_call_session.dart';
import 'package:roomtime/data/services/livekit_room_driver.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/services/call_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../helpers/fakes.dart';

class FakeForegroundService extends CallForegroundService {
  int starts = 0;
  int stops = 0;

  @override
  Future<void> start() async => starts++;

  @override
  Future<void> stop() async => stops++;
}

/// Driver whose steps the test holds open and whose calls it records.
class FakeDriver implements MediaRoomDriver {
  void Function(MediaRoomEvent event)? _onEvent;
  Completer<void>? pendingConnect;
  Completer<void>? pendingMicrophone;
  Object? connectError;
  Object? startAudioError;

  /// Thrown by `setMicrophoneEnabled(true)` (blocked or missing device).
  Object? microphoneError;

  /// Thrown by `setCameraEnabled(true)`.
  Object? cameraError;
  final microphoneCalls = <bool>[];
  final cameraCalls = <bool>[];
  int closeCalls = 0;
  bool closed = false;
  bool mic = false;
  bool camera = false;
  List<CallParticipant> people = const [localParticipant];

  void emit(MediaRoomEvent event) => _onEvent?.call(event);

  @override
  void listen(void Function(MediaRoomEvent event) onEvent) =>
      _onEvent = onEvent;

  @override
  Future<void> connect(String url, String token) async {
    final error = connectError;
    if (error != null) throw error;
    await pendingConnect?.future;
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    microphoneCalls.add(enabled);
    await pendingMicrophone?.future;
    final error = microphoneError;
    if (enabled && error != null) throw error;
    mic = enabled;
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    cameraCalls.add(enabled);
    final error = cameraError;
    if (enabled && error != null) throw error;
    camera = enabled;
  }

  @override
  Future<bool> switchCamera({required bool front}) async => true;

  @override
  Future<void> startAudio() async {
    final error = startAudioError;
    if (error != null) throw error;
  }

  @override
  List<CallParticipant> participants() => people;

  @override
  bool get microphoneEnabled => mic;

  @override
  bool get cameraEnabled => camera;

  @override
  bool get audioPlaybackBlocked => false;

  @override
  Future<void> close() async {
    closeCalls++;
    closed = true;
  }
}

// the adapter's lifecycle against a fake media room.
void main() {
  late FakeForegroundService foreground;
  late List<FakeDriver> drivers;
  late FakeDriver Function() nextDriver;

  const options = CallConnectOptions(url: 'wss://media.test', token: 't');

  setUp(() {
    foreground = FakeForegroundService();
    drivers = [];
    nextDriver = FakeDriver.new;
  });

  LiveKitCallSession build() => LiveKitCallSession(
    foreground,
    createDriver: () {
      final driver = nextDriver();
      drivers.add(driver);
      return driver;
    },
    canSwitchSpeakerphone: () => false,
    speakerPreferred: () => false,
  );

  test(
    'connect publishes the requested tracks and reports connected',
    () async {
      final session = build();
      await session.connect(options);

      final driver = drivers.single;
      expect(driver.microphoneCalls, [true]);
      expect(driver.cameraCalls, [true]);
      expect(session.snapshot.connection, CallConnection.connected);
      expect(session.snapshot.participants, [localParticipant]);
      expect(foreground.starts, 1);
      await session.dispose();
    },
  );

  test('leave during connect waits for the attempt: nothing is published, '
      'the room is closed once', () async {
    nextDriver = () => FakeDriver()..pendingConnect = Completer<void>();
    final session = build();
    final connecting = session.connect(options);
    await Future<void>.delayed(Duration.zero);

    final leaving = session.leave();
    drivers.single.pendingConnect!.complete();
    await connecting;
    await leaving;

    final driver = drivers.single;
    expect(driver.microphoneCalls, isEmpty);
    expect(driver.cameraCalls, isEmpty);
    expect(driver.closeCalls, 1);
    expect(session.snapshot.connection, CallConnection.disconnected);
    expect(session.snapshot.endReason, CallEndReason.left);
  });

  test('a remote disconnect during publishing tears down once and stops '
      'publishing into the dead room', () async {
    nextDriver = () => FakeDriver()..pendingMicrophone = Completer<void>();
    final session = build();
    final connecting = session.connect(options);
    await Future<void>.delayed(Duration.zero);
    final driver = drivers.single;
    expect(driver.microphoneCalls, [true]);

    driver.emit(const MediaRoomDisconnected(CallEndReason.removed));
    await Future<void>.delayed(Duration.zero);
    driver.pendingMicrophone!.complete();
    await connecting;

    expect(driver.cameraCalls, isEmpty);
    expect(driver.closeCalls, 1);
    expect(foreground.stops, 1);
    expect(session.snapshot.endReason, CallEndReason.removed);

    await session.dispose();
    expect(driver.closeCalls, 1);
  });

  test('a failed connect closes the room and allows a retry', () async {
    nextDriver = () => FakeDriver()
      ..connectError = lk.ConnectException(
        '<html>503',
        reason: lk.ConnectionErrorReason.NotAllowed,
        statusCode: 503,
      );
    final session = build();
    await expectLater(
      session.connect(options),
      throwsA(const ServerFailure(statusCode: 503)),
    );
    expect(drivers.single.closeCalls, 1);

    nextDriver = FakeDriver.new;
    await session.connect(options);
    expect(drivers, hasLength(2));
    expect(session.snapshot.connection, CallConnection.connected);
    await session.dispose();
  });

  test('dispose twice tears down once', () async {
    final session = build();
    await session.connect(options);
    await session.dispose();
    await session.dispose();
    expect(drivers.single.closeCalls, 1);
  });

  test('room events map to snapshots', () async {
    final session = build();
    final seen = <CallConnection>[];
    session.snapshots.listen((s) => seen.add(s.connection));
    await session.connect(options);
    final driver = drivers.single;

    driver.emit(const MediaRoomReconnecting());
    driver.emit(const MediaRoomReconnected());
    driver.people = const [localParticipant, remoteParticipant];
    driver.emit(const MediaRoomChanged());
    driver.emit(const MediaRoomDisconnected(CallEndReason.joinedElsewhere));
    await Future<void>.delayed(Duration.zero);

    expect(
      seen,
      containsAllInOrder([
        CallConnection.reconnecting,
        CallConnection.connected,
        CallConnection.disconnected,
      ]),
    );
    expect(session.snapshot.endReason, CallEndReason.joinedElsewhere);
    expect(session.snapshot.participants, isEmpty);
    await session.dispose();
  });

  // every command error is a Failure.
  test('startAudio errors surface as MediaDeviceFailure', () async {
    nextDriver = () => FakeDriver()..startAudioError = StateError('blocked');
    final session = build();
    await session.connect(options);
    await expectLater(
      session.startAudio(),
      throwsA(const MediaDeviceFailure()),
    );
    await session.dispose();
  });

  // a microphone that fails at join is reported, not just logged.
  test('a microphone that cannot open at join is flagged until a toggle '
      'succeeds', () async {
    nextDriver = () => FakeDriver()..microphoneError = StateError('busy');
    final session = build();
    await session.connect(options);
    final driver = drivers.single;

    expect(session.snapshot.connection, CallConnection.connected);
    expect(session.snapshot.microphoneEnabled, isFalse);
    expect(session.snapshot.microphoneUnavailable, isTrue);
    expect(driver.cameraCalls, [true], reason: 'the camera still joins');

    await expectLater(
      session.setMicrophoneEnabled(true),
      throwsA(const MediaDeviceFailure()),
    );
    expect(session.snapshot.microphoneUnavailable, isTrue);

    driver.microphoneError = null;
    await session.setMicrophoneEnabled(true);
    expect(session.snapshot.microphoneEnabled, isTrue);
    expect(session.snapshot.microphoneUnavailable, isFalse);
    await session.dispose();
  });

  // a browser that blocks camera and microphone (web throws a plain
  // String from getUserMedia) still joins, receive-only, never a failure.
  test('blocked camera and microphone still connect receive-only', () async {
    const denied = 'Unable to getUserMedia: NotAllowedError: Permission denied';
    nextDriver = () => FakeDriver()
      ..microphoneError = denied
      ..cameraError = denied;
    final session = build();
    await session.connect(options);

    expect(session.snapshot.connection, CallConnection.connected);
    expect(session.snapshot.microphoneEnabled, isFalse);
    expect(session.snapshot.cameraEnabled, isFalse);
    expect(session.snapshot.microphoneUnavailable, isTrue);
    expect(drivers.single.closeCalls, 0);
    await session.dispose();
  });

  test('joining muted on purpose is not a microphone failure', () async {
    nextDriver = () => FakeDriver()..microphoneError = StateError('busy');
    final session = build();
    await session.connect(
      const CallConnectOptions(
        url: 'wss://media.test',
        token: 't',
        microphoneEnabled: false,
      ),
    );
    expect(session.snapshot.microphoneUnavailable, isFalse);
    await session.dispose();
  });

  test('LiveKit disconnect reasons map to end reasons', () {
    expect(
      LiveKitRoomDriver.endReason(lk.DisconnectReason.participantRemoved),
      CallEndReason.removed,
    );
    expect(
      LiveKitRoomDriver.endReason(lk.DisconnectReason.duplicateIdentity),
      CallEndReason.joinedElsewhere,
    );
    expect(LiveKitRoomDriver.endReason(null), CallEndReason.connectionLost);
  });

  test('poor and lost connection quality read as weak', () {
    expect(LiveKitRoomDriver.isWeak(lk.ConnectionQuality.poor), isTrue);
    expect(LiveKitRoomDriver.isWeak(lk.ConnectionQuality.lost), isTrue);
    expect(LiveKitRoomDriver.isWeak(lk.ConnectionQuality.good), isFalse);
    expect(LiveKitRoomDriver.isWeak(lk.ConnectionQuality.unknown), isFalse);
  });
}
