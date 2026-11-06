import 'dart:async';
import 'dart:ui' show AppLifecycleState;

import 'package:bloc_test/bloc_test.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late FakeRoomRepository rooms;
  late FakeCallSession session;
  late SilentAudioService audio;
  late FixedClock clock;

  setUp(() {
    rooms = FakeRoomRepository();
    session = FakeCallSession();
    audio = SilentAudioService();
    clock = FixedClock(DateTime.utc(2026, 11, 3, 12));
  });

  RoomBloc build({
    bool pauseCameraInBackground = true,
    bool startAudioOnJoin = false,
  }) => RoomBloc(
    rooms,
    FakeGuestProfileRepository(),
    session,
    audio,
    clock,
    pauseCameraInBackground: pauseCameraInBackground,
    startAudioOnJoin: startAudioOnJoin,
  );

  RoomJoinRequested join({String? password, bool camera = true}) =>
      RoomJoinRequested(
        code: testCode,
        password: password,
        cameraEnabled: camera,
      );

  final connected = RoomConnected(
    room: sampleJoin().room,
    role: RoomRole.participant,
    call: FakeCallSession.connectedSnapshot,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  group('connect', () {
    blocTest<RoomBloc, RoomState>(
      'join then media connect -> Connecting, Connected',
      build: build,
      act: (bloc) => bloc.add(join()),
      expect: () => [RoomConnecting(testCode), connected],
      verify: (_) {
        expect(session.connectedWith?.token, 'lk-token');
        expect(session.connectedWith?.url, 'wss://media.test');
      },
    );

    blocTest<RoomBloc, RoomState>(
      'a failed join -> Failed, the media session is never opened',
      build: () {
        rooms.onJoin = (_, _) => Future.error(const RoomFullFailure());
        return build();
      },
      act: (bloc) => bloc.add(join()),
      expect: () => [
        RoomConnecting(testCode),
        RoomFailed(code: testCode, failure: const RoomFullFailure()),
      ],
      verify: (_) => expect(session.connectCalls, 0),
    );

    blocTest<RoomBloc, RoomState>(
      'password required, then retry with the password -> Connected',
      build: () {
        rooms.onJoin = (_, password) => password == null
            ? Future.error(const PasswordRequiredFailure())
            : Future.value(sampleJoin());
        return build();
      },
      act: (bloc) async {
        bloc.add(join());
        await settle();
        bloc.add(join(password: 'secret'));
      },
      expect: () => [
        RoomConnecting(testCode),
        RoomFailed(code: testCode, failure: const PasswordRequiredFailure()),
        RoomConnecting(testCode),
        connected,
      ],
      verify: (_) => expect(rooms.joinPasswords, [null, 'secret']),
    );

    blocTest<RoomBloc, RoomState>(
      'a media connect failure -> Failed',
      build: () {
        session.connectError = const NetworkFailure();
        return build();
      },
      act: (bloc) => bloc.add(join()),
      expect: () => [
        RoomConnecting(testCode),
        RoomFailed(code: testCode, failure: const NetworkFailure()),
      ],
    );
  });

  group('leaving while connecting', () {
    test('close during the API join: connect is never called, the session '
        'is disposed once', () async {
      rooms.pendingJoin = Completer<RoomJoin>();
      final bloc = build()..add(join());
      await settle();

      await bloc.close();
      rooms.pendingJoin!.complete(sampleJoin());
      await settle();

      expect(session.connectCalls, 0);
      expect(session.disposeCalls, 1);
    });

    blocTest<RoomBloc, RoomState>(
      'leave during the API join -> Ended(left), no media connect',
      build: () {
        rooms.pendingJoin = Completer<RoomJoin>();
        return build();
      },
      act: (bloc) async {
        bloc.add(join());
        await settle();
        bloc.add(const RoomLeaveRequested());
        await settle();
        rooms.pendingJoin!.complete(sampleJoin());
      },
      expect: () => [
        RoomConnecting(testCode),
        const RoomEnded(CallEndReason.left),
      ],
      verify: (_) {
        expect(session.connectCalls, 0);
        expect(session.leaveCalls, greaterThanOrEqualTo(1));
      },
    );

    blocTest<RoomBloc, RoomState>(
      'leave during the media connect -> session left, never Connected',
      build: () {
        session.pendingConnect = Completer<void>();
        return build();
      },
      act: (bloc) async {
        bloc.add(join());
        await settle();
        expect(session.connectCalls, 1);
        bloc.add(const RoomLeaveRequested());
        await settle();
        session.pendingConnect!.complete();
      },
      expect: () => [
        RoomConnecting(testCode),
        RoomEnded(CallEndReason.left, code: testCode),
      ],
      verify: (_) {
        expect(session.leaveCalls, greaterThanOrEqualTo(1));
        expect(session.snapshot.connection, CallConnection.disconnected);
      },
    );
  });

  group('connection events', () {
    blocTest<RoomBloc, RoomState>(
      'reconnecting and reconnected',
      build: build,
      act: (bloc) async {
        bloc.add(join());
        await settle();
        session.emit(
          FakeCallSession.connectedSnapshot.copyWith(
            connection: CallConnection.reconnecting,
          ),
        );
        await settle();
        session.emit(FakeCallSession.connectedSnapshot);
      },
      skip: 2,
      expect: () => [
        RoomReconnecting(
          room: sampleJoin().room,
          role: RoomRole.participant,
          call: FakeCallSession.connectedSnapshot.copyWith(
            connection: CallConnection.reconnecting,
          ),
        ),
        connected,
      ],
    );

    blocTest<RoomBloc, RoomState>(
      'room deleted before expiry -> Ended(endedByHost)',
      build: build,
      act: (bloc) async {
        bloc.add(join());
        await settle();
        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.roomDeleted,
          ),
        );
      },
      skip: 2,
      expect: () => [RoomEnded(CallEndReason.endedByHost, code: testCode)],
    );

    blocTest<RoomBloc, RoomState>(
      'room deleted after expiry -> Ended(roomDeleted)',
      build: () {
        clock.current = DateTime.utc(2031);
        return build();
      },
      act: (bloc) async {
        bloc.add(join());
        await settle();
        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.roomDeleted,
          ),
        );
      },
      skip: 2,
      expect: () => [RoomEnded(CallEndReason.roomDeleted, code: testCode)],
    );

    blocTest<RoomBloc, RoomState>(
      'removed after expiry -> Ended(roomDeleted)',
      build: build,
      act: (bloc) async {
        bloc.add(join());
        await settle();
        clock.current = DateTime.utc(2031);
        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.removed,
          ),
        );
      },
      skip: 2,
      expect: () => [RoomEnded(CallEndReason.roomDeleted, code: testCode)],
    );

    blocTest<RoomBloc, RoomState>(
      'removed by the host and connection lost keep their reason',
      build: build,
      act: (bloc) async {
        bloc.add(join());
        await settle();
        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.removed,
          ),
        );
        await settle();
        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.connectionLost,
          ),
        );
      },
      skip: 2,
      expect: () => [RoomEnded(CallEndReason.removed, code: testCode)],
    );

    blocTest<RoomBloc, RoomState>(
      'host ends the call for everyone -> API end, session left, '
      'Ended(endedByHost)',
      build: () {
        rooms.onJoin = (_, _) async => sampleJoin(role: RoomRole.host);
        return build();
      },
      act: (bloc) async {
        bloc.add(join());
        await settle();
        bloc.add(const RoomEndForAllRequested());
      },
      skip: 2,
      expect: () => [
        RoomEnded(CallEndReason.endedByHost, code: testCode, endedByYou: true),
      ],
      verify: (_) {
        expect(rooms.endCalls, 1);
        expect(session.leaveCalls, greaterThanOrEqualTo(1));
      },
    );

    blocTest<RoomBloc, RoomState>(
      'a participant cannot end the call for everyone',
      build: build,
      act: (bloc) async {
        bloc.add(join());
        await settle();
        bloc.add(const RoomEndForAllRequested());
      },
      skip: 2,
      expect: () => <RoomState>[],
      verify: (_) => expect(rooms.endCalls, 0),
    );
  });

  group('app lifecycle camera', () {
    test('pauses the camera in the background and restores it', () async {
      final bloc = build()..add(join());
      await settle();

      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.inactive));
      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.hidden));
      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.paused));
      await settle();
      expect(session.cameraCommands, [false]);
      expect((bloc.state as RoomInCall).call.cameraEnabled, isFalse);

      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.resumed));
      await settle();
      expect(session.cameraCommands, [false, true]);
      expect((bloc.state as RoomInCall).call.cameraEnabled, isTrue);
      await bloc.close();
    });

    test('does not turn on a camera the user had switched off', () async {
      final bloc = build()..add(join(camera: false));
      await settle();

      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.paused));
      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.resumed));
      await settle();

      expect(session.cameraCommands, isEmpty);
      await bloc.close();
    });

    test('leaves the camera alone where background capture is fine '
        '(web/desktop)', () async {
      final bloc = build(pauseCameraInBackground: false)..add(join());
      await settle();

      bloc.add(const RoomAppLifecycleChanged(AppLifecycleState.hidden));
      await settle();

      expect(session.cameraCommands, isEmpty);
      await bloc.close();
    });
  });

  group('effects and commands', () {
    test('announces joins and leaves once connected', () async {
      final bloc = build()..add(join());
      final effects = <RoomEffect>[];
      final subscription = bloc.effects.listen(effects.add);
      await settle();

      session.emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, remoteParticipant],
        ),
      );
      await settle();
      session.emit(FakeCallSession.connectedSnapshot);
      await settle();

      expect(effects, [
        isA<ParticipantJoinedEffect>().having(
          (e) => e.participant.displayName,
          'name',
          'Bob',
        ),
        isA<ParticipantLeftEffect>(),
      ]);
      expect(audio.joins, 1);
      expect(audio.leaves, 1);
      await subscription.cancel();
      await bloc.close();
    });

    test(
      'no leave effects when the call ends (disconnected, empty list)',
      () async {
        final bloc = build()..add(join());
        final effects = <RoomEffect>[];
        final subscription = bloc.effects.listen(effects.add);
        await settle();
        session.emit(
          FakeCallSession.connectedSnapshot.copyWith(
            participants: [localParticipant, remoteParticipant],
          ),
        );
        await settle();
        effects.clear();

        session.emit(
          const CallSnapshot(
            connection: CallConnection.disconnected,
            endReason: CallEndReason.roomDeleted,
          ),
        );
        await settle();

        expect(effects, isEmpty);
        expect(audio.leaves, 0);
        expect(bloc.state, isA<RoomEnded>());
        await subscription.cancel();
        await bloc.close();
      },
    );

    test('a full reconnect that restores the same people announces nothing; '
        'a real leave afterwards is announced once', () async {
      final bloc = build()..add(join());
      final effects = <RoomEffect>[];
      final subscription = bloc.effects.listen(effects.add);
      await settle();
      final withBob = FakeCallSession.connectedSnapshot.copyWith(
        participants: [localParticipant, remoteParticipant],
      );
      session.emit(withBob);
      await settle();
      effects.clear();
      audio
        ..joins = 0
        ..leaves = 0;

      session.emit(
        FakeCallSession.connectedSnapshot.copyWith(
          connection: CallConnection.reconnecting,
          participants: [localParticipant],
        ),
      );
      await settle();
      session.emit(withBob.copyWith(connection: CallConnection.reconnecting));
      await settle();
      session.emit(withBob);
      await settle();
      expect(effects, isEmpty);
      expect((audio.joins, audio.leaves), (0, 0));

      session.emit(FakeCallSession.connectedSnapshot);
      await settle();
      expect(effects, [isA<ParticipantLeftEffect>()]);
      expect(audio.leaves, 1);
      await subscription.cancel();
      await bloc.close();
    });

    test('state follows the session, not the command', () async {
      final bloc = build()..add(join());
      await settle();

      bloc.add(const RoomMicrophoneToggled(false));
      await settle();

      expect(session.microphoneCommands, [false]);
      expect((bloc.state as RoomInCall).call.microphoneEnabled, isFalse);
      await bloc.close();
    });

    test('closing the bloc disposes the session exactly once', () async {
      final bloc = build()..add(join());
      await settle();
      bloc.add(const RoomLeaveRequested());
      await settle();

      await bloc.close();

      expect(session.disposeCalls, 1);
    });
  });

  group('host settings and expiry', () {
    RoomBloc hostBloc({DateTime? expiresAt}) {
      rooms.onJoin = (_, _) async =>
          sampleJoin(role: RoomRole.host, expiresAt: expiresAt);
      return build();
    }

    test(
      'lock and password changes go to the API and update the room',
      () async {
        final bloc = hostBloc()..add(join());
        final effects = <RoomEffect>[];
        final subscription = bloc.effects.listen(effects.add);
        await settle();

        bloc.add(const RoomLockRequested(true));
        await settle();
        bloc.add(const RoomPasswordChangeRequested('new-pass'));
        await settle();

        expect(rooms.patches.first.locked, isTrue);
        expect(rooms.patches.last.password, isA<SetPassword>());
        final state = bloc.state as RoomInCall;
        expect(state.room.locked, isTrue);
        expect(state.room.passwordRequired, isTrue);
        expect(
          effects.whereType<RoomSettingsChangedEffect>().map((e) => e.change),
          [RoomSettingsChange.locked, RoomSettingsChange.passwordSet],
        );
        await subscription.cancel();
        await bloc.close();
      },
    );

    test(
      'rotating the invite switches the room to the new code and link',
      () async {
        final bloc = hostBloc()..add(join());
        await settle();

        bloc.add(const RoomInviteRotateRequested());
        await settle();

        final state = bloc.state as RoomInCall;
        expect(state.room.code.value, 'zzzzzzzzzz');
        expect(state.inviteUrl, Uri.parse('https://calls.test/r/zzz-zzzz-zzz'));

        bloc.add(const RoomLeaveRequested());
        await settle();
        expect((bloc.state as RoomEnded).code?.value, 'zzzzzzzzzz');
        await bloc.close();
      },
    );

    test(
      'a failed invite rotation emits RoomActionFailedEffect and keeps the current code',
      () async {
        final bloc = hostBloc()..add(join());
        final effects = <RoomEffect>[];
        final subscription = bloc.effects.listen(effects.add);
        await settle();
        rooms.hostError = const ServerFailure(statusCode: 503);

        bloc.add(const RoomInviteRotateRequested());
        await settle();

        final state = bloc.state as RoomInCall;
        expect(state.room.code, testCode);
        expect(effects, [
          isA<RoomActionFailedEffect>().having(
            (e) => e.failure,
            'failure',
            const ServerFailure(statusCode: 503),
          ),
        ]);
        await subscription.cancel();
        await bloc.close();
      },
    );

    test('a participant cannot change room settings', () async {
      final bloc = build()..add(join());
      await settle();
      bloc.add(const RoomLockRequested(true));
      bloc.add(const RoomInviteRotateRequested());
      await settle();
      expect(rooms.patches, isEmpty);
      expect(rooms.rotateCalls, 0);
      await bloc.close();
    });

    test('host is warned 10 minutes before expiresAt', () async {
      final bloc = hostBloc(
        expiresAt: clock.current.add(const Duration(minutes: 5)),
      )..add(join());
      await settle();
      await settle();
      expect((bloc.state as RoomInCall).expiresSoon, isTrue);
      await bloc.close();
    });

    test('no warning long before expiry', () async {
      final bloc = hostBloc(
        expiresAt: clock.current.add(const Duration(hours: 4)),
      )..add(join());
      await settle();
      expect((bloc.state as RoomInCall).expiresSoon, isFalse);
      await bloc.close();
    });

    testWidgets('the warning fires once the lead time is reached', (
      tester,
    ) async {
      final bloc = hostBloc(
        expiresAt: clock.current.add(const Duration(minutes: 30)),
      )..add(join());
      await tester.pump();
      expect((bloc.state as RoomInCall).expiresSoon, isFalse);

      await tester.pump(const Duration(minutes: 19, seconds: 59));
      expect((bloc.state as RoomInCall).expiresSoon, isFalse);

      await tester.pump(const Duration(seconds: 1));
      expect((bloc.state as RoomInCall).expiresSoon, isTrue);
      await tester.runAsync(bloc.close);
    });

    test('End for everyone: a disconnect before the 204 gives exactly one '
        'Ended(endedByYou)', () async {
      final bloc = hostBloc()..add(join());
      final states = <RoomState>[];
      final subscription = bloc.stream.listen(states.add);
      await settle();
      states.clear();
      rooms.pendingEnd = Completer<void>();

      bloc.add(const RoomEndForAllRequested());
      await settle();
      session.emit(
        const CallSnapshot(
          connection: CallConnection.disconnected,
          endReason: CallEndReason.roomDeleted,
        ),
      );
      await settle();
      rooms.pendingEnd!.complete();
      await settle();

      expect(states, [
        RoomEnded(CallEndReason.endedByHost, code: testCode, endedByYou: true),
      ]);
      await subscription.cancel();
      await bloc.close();
    });

    test('End for everyone: a lost connection while the request fails stays '
        'connectionLost', () async {
      final bloc = hostBloc()..add(join());
      final states = <RoomState>[];
      final subscription = bloc.stream.listen(states.add);
      await settle();
      states.clear();
      rooms.pendingEnd = Completer<void>();

      bloc.add(const RoomEndForAllRequested());
      await settle();
      session.emit(
        const CallSnapshot(
          connection: CallConnection.disconnected,
          endReason: CallEndReason.connectionLost,
        ),
      );
      await settle();
      rooms.hostError = const NetworkFailure();
      rooms.pendingEnd!.complete();
      await settle();

      expect(states, [RoomEnded(CallEndReason.connectionLost, code: testCode)]);
      await subscription.cancel();
      await bloc.close();
    });

    test('End for everyone that fails keeps the call and reports it', () async {
      final bloc = hostBloc()..add(join());
      final effects = <RoomEffect>[];
      final subscription = bloc.effects.listen(effects.add);
      await settle();
      rooms.hostError = const NetworkFailure();

      bloc.add(const RoomEndForAllRequested());
      await settle();

      expect(bloc.state, isA<RoomConnected>());
      expect(effects.single, isA<RoomActionFailedEffect>());
      await subscription.cancel();
      await bloc.close();
    });

    for (final (name, event) in [
      (
        'mute',
        const RoomParticipantMuteRequested(
          identity: 'p_bob',
          trackSid: 'TR_audio',
        ),
      ),
      ('remove', const RoomParticipantRemoveRequested(identity: 'p_bob')),
    ]) {
      test('a failed $name gives one RoomActionFailedEffect', () async {
        final bloc = hostBloc()..add(join());
        final effects = <RoomEffect>[];
        final subscription = bloc.effects.listen(effects.add);
        await settle();
        final before = bloc.state;
        rooms.hostError = const ServerFailure(statusCode: 503);

        bloc.add(event);
        await settle();

        expect(effects, hasLength(1));
        expect(
          (effects.single as RoomActionFailedEffect).failure,
          const ServerFailure(statusCode: 503),
        );
        expect(bloc.state, before);
        await subscription.cancel();
        await bloc.close();
      });
    }
  });

  group('join details', () {
    test('the lobby name is saved before joining', () async {
      final profiles = FakeGuestProfileRepository();
      final bloc = RoomBloc(
        rooms,
        profiles,
        session,
        audio,
        clock,
        pauseCameraInBackground: false,
        startAudioOnJoin: false,
      )..add(RoomJoinRequested(code: testCode, displayName: 'Grandma'));
      await settle();
      expect(profiles.profile.displayName, 'Grandma');
      await bloc.close();
    });

    test('web: the join gesture also starts audio playback', () async {
      session.emit(const CallSnapshot());
      final bloc = build(startAudioOnJoin: true)..add(join());
      await settle();
      expect(bloc.state, isA<RoomConnected>());
      expect(session.startAudioCalls, 1);
      await bloc.close();
    });
  });

  test('password events do not print the password', () {
    expect(join(password: 'hunter22').toString(), isNot(contains('hunter22')));
    expect(
      const RoomPasswordChangeRequested('hunter22').toString(),
      isNot(contains('hunter22')),
    );
  });
}
