import 'dart:async';

import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/presentation/features/room/bloc/lobby_cubit.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/view/call_view.dart';
import 'package:roomtime/presentation/features/room/view/room_screen.dart';
import 'package:roomtime/presentation/dialogs/glass_dialog.dart';
import 'package:roomtime/presentation/features/room/widgets/media_controls.dart';
import 'package:roomtime/presentation/features/room/widgets/participants_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/fakes.dart';
import '../feature_harness.dart';
import 'package:roomtime/l10n/app_localizations.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

const bob = CallParticipant(
  id: 'PA_bob',
  identity: 'p_bob',
  displayName: 'Bob',
  isLocal: false,
  microphoneEnabled: true,
  audioTrackSid: 'TR_audio',
);

void main() {
  late FakeRoomRepository rooms;
  late FakeGuestProfileRepository profiles;
  late FakeMediaPreview preview;
  late List<FakeCallSession> sessions;

  FakeCallSession session() => sessions.last;

  setUp(() {
    rooms = FakeRoomRepository();
    profiles = FakeGuestProfileRepository();
    preview = FakeMediaPreview();
    sessions = [];
  });

  Future<void> pumpRoom(
    WidgetTester tester, {
    Size size = const Size(400, 800),
    double textScale = 1,
    bool accessibleNavigation = false,
    RoomExitGuard? exitGuard,
  }) async {
    await pumpRouterApp(
      tester,
      size: size,
      textScale: textScale,
      accessibleNavigation: accessibleNavigation,
      location: '/r/abcdefghjk',
      routes: [
        placeholderRoute('/'),
        GoRoute(
          path: '/r/:code',
          builder: (context, state) => RoomScreen(
            code: testCode,
            exitGuard: exitGuard,
            createRoomBloc: () {
              final session = FakeCallSession();
              sessions.add(session);
              return RoomBloc(
                rooms,
                profiles,
                session,
                SilentAudioService(),
                FixedClock(DateTime.utc(2026, 11, 4, 12)),
              );
            },
            createLobbyCubit: () {
              preview = FakeMediaPreview()
                ..cameraAccess = preview.cameraAccess
                ..microphoneAccess = preview.microphoneAccess;
              return LobbyCubit(rooms, profiles, preview);
            },
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();
  }

  Finder control(String label) => find.byWidgetPredicate(
    (w) =>
        w is MediaControlButton &&
        (w.label == label || w.label.startsWith('$label, ')),
  );

  Finder joinButton() => find.byWidgetPredicate(
    (w) => w is GlassDialogButton && w.label == l10n.roomJoin,
  );

  Future<void> joinCall(WidgetTester tester) async {
    await tapVisible(tester, joinButton());
  }

  /// Joins as host and puts Bob in the call.
  Future<void> hostWithBob(WidgetTester tester, {Size? size}) async {
    rooms
      ..owner = true
      ..onJoin = (_, _) async => sampleJoin(role: RoomRole.host);
    await pumpRoom(tester, size: size ?? const Size(400, 800));
    await joinCall(tester);
    session().emit(
      FakeCallSession.connectedSnapshot.copyWith(
        participants: [localParticipant, bob],
      ),
    );
    await tester.pumpAndSettle();
  }

  group('lobby', () {
    testWidgets('looks the room up, starts the preview, joins on tap', (
      tester,
    ) async {
      await pumpRoom(tester);

      expect(rooms.lookupCalls, 1);
      expect(preview.startCalls, 1);
      expect(find.text('Family'), findsWidgets);
      final name = tester.widget<TextField>(
        find.widgetWithText(TextField, l10n.roomNameLabel),
      );
      expect(name.controller!.text, 'Ann');

      await joinCall(tester);

      expect(preview.releaseCalls, 1);
      expect(session().connectedWith?.cameraEnabled, isTrue);
      expect(find.byType(CallView), findsOneWidget);
    });

    testWidgets('wrong password: field cleared with an error, preview '
        'restarts', (tester) async {
      rooms
        ..lookupResult = sampleSummary(passwordRequired: true, name: null)
        ..onJoin = (_, password) => password == 'right'
            ? Future.value(sampleJoin())
            : Future.error(const InvalidPasswordFailure());
      await pumpRoom(tester);

      final passwordField = find.widgetWithText(
        TextField,
        l10n.roomPasswordLabel,
      );
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'wrong');
      await joinCall(tester);

      expect(find.text(l10n.roomWrongPassword), findsOneWidget);
      // QA D4: the field is emptied, not selected, and Join waits for input.
      expect(tester.widget<TextField>(passwordField).controller!.text, isEmpty);
      expect(tester.widget<GlassDialogButton>(joinButton()).onPressed, isNull);
      expect(rooms.joinPasswords, ['wrong']);
      expect(preview.startCalls, 2);
      expect(find.byType(CallView), findsNothing);

      await tester.enterText(passwordField, 'right');
      await joinCall(tester);
      expect(find.byType(CallView), findsOneWidget);
    });

    // QA D2: the password is sent exactly as typed, spaces included.
    testWidgets('the lobby sends the password verbatim, not trimmed', (
      tester,
    ) async {
      rooms.lookupResult = sampleSummary(passwordRequired: true);
      await pumpRoom(tester);
      await tester.enterText(
        find.widgetWithText(TextField, l10n.roomPasswordLabel),
        ' Pa ss ',
      );
      await joinCall(tester);

      expect(rooms.joinPasswords, [' Pa ss ']);
    });

    testWidgets('429: countdown, Join disabled until it reaches zero', (
      tester,
    ) async {
      rooms
        ..lookupResult = sampleSummary(passwordRequired: true)
        ..onJoin = (_, _) => Future.error(
          const TooManyAttemptsFailure(retryAfter: Duration(seconds: 3)),
        );
      await pumpRoom(tester);
      await tester.enterText(
        find.widgetWithText(TextField, l10n.roomPasswordLabel),
        'guess',
      );
      await joinCall(tester);

      expect(find.text(l10n.roomTooManyAttempts('0:03')), findsOneWidget);
      expect(tester.widget<GlassDialogButton>(joinButton()).onPressed, isNull);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text(l10n.roomTooManyAttempts('0:02')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text(l10n.roomCanTryAgain), findsOneWidget);
      expect(
        tester.widget<GlassDialogButton>(joinButton()).onPressed,
        isNotNull,
      );
    });

    testWidgets('camera off in the lobby joins with audio only', (
      tester,
    ) async {
      await pumpRoom(tester);

      await tapVisible(tester, control(l10n.roomCamera));
      await joinCall(tester);

      expect(session().connectedWith?.cameraEnabled, isFalse);
      expect(session().connectedWith?.microphoneEnabled, isTrue);
      expect(find.byType(CallView), findsOneWidget);
    });

    testWidgets('a blocked microphone is explained and joins muted', (
      tester,
    ) async {
      preview.microphoneAccess = DeviceAccess.denied;
      await pumpRoom(tester);

      expect(find.textContaining('Microphone is blocked'), findsOneWidget);
      await joinCall(tester);

      expect(session().connectedWith?.microphoneEnabled, isFalse);
    });

    testWidgets('locked, banned and full get dedicated screens', (
      tester,
    ) async {
      rooms.onJoin = (_, _) => Future.error(const RoomLockedFailure());
      await pumpRoom(tester);
      await joinCall(tester);
      expect(find.text(l10n.roomLockedTitle), findsOneWidget);

      // "Try again" starts a fresh attempt from the lobby.
      rooms.onJoin = (_, _) => Future.error(const ParticipantBannedFailure());
      await tapVisible(tester, find.text(l10n.roomTryAgain));
      expect(rooms.lookupCalls, 2);
      await joinCall(tester);
      expect(find.text(l10n.roomBannedTitle), findsOneWidget);
    });

    testWidgets('unknown, expired or revoked code: one Room not found screen', (
      tester,
    ) async {
      rooms.lookupResult = const RoomNotFoundFailure();
      await pumpRoom(tester);

      expect(find.text(l10n.roomNotFoundTitle), findsOneWidget);
      await tapVisible(tester, find.text(l10n.roomHome));
      expect(find.text('at /'), findsOneWidget);
    });

    testWidgets('host sees the invite card in the lobby', (tester) async {
      rooms.owner = true;
      await pumpRoom(tester);
      expect(find.text(l10n.inviteCodeLabel), findsOneWidget);
      expect(find.text(l10n.inviteCopyLink), findsOneWidget);
      expect(find.text(l10n.roomHostNotice), findsOneWidget);
    });
  });

  group('call', () {
    testWidgets('host Leave: sheet, confirm with Escape does nothing, '
        'confirm ends for everyone', (tester) async {
      await hostWithBob(tester);

      await tester.tap(control(l10n.roomLeave));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomLeaveLeave), findsOneWidget);
      await tester.tap(find.text(l10n.roomLeaveEnd));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomLeaveConfirmTitle), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomLeaveConfirmTitle), findsNothing);
      expect(rooms.endCalls, 0);
      expect(session().leaveCalls, 0);
      expect(find.byType(CallView), findsOneWidget);

      await tester.tap(control(l10n.roomLeave));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomLeaveEnd));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomLeaveConfirm));
      await tester.pumpAndSettle();

      expect(rooms.endCalls, 1);
      expect(find.text(l10n.roomEndedByYou), findsOneWidget);
    });

    testWidgets('a participant leaves at once, then can rejoin through the '
        'lobby with a fresh join', (tester) async {
      await pumpRoom(tester);
      await joinCall(tester);

      await tester.tap(control(l10n.roomLeave));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomEndedLeft), findsOneWidget);

      await tapVisible(tester, find.text(l10n.roomRejoin));
      expect(sessions, hasLength(2));
      await joinCall(tester);
      expect(rooms.joinPasswords, hasLength(2));
      expect(find.byType(CallView), findsOneWidget);
    });

    testWidgets('participants panel actions call the repository', (
      tester,
    ) async {
      await hostWithBob(tester, size: const Size(1200, 800));

      await tester.tap(control(l10n.roomParticipants));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomPeopleTitle(2)), findsOneWidget);

      await tester.tap(find.text(l10n.roomLock));
      await tester.pumpAndSettle();
      expect(rooms.patches.single.locked, isTrue);

      await tester.tap(find.byTooltip(l10n.roomOptionsFor('Bob')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomMute));
      await tester.pumpAndSettle();
      expect(rooms.mutes, [('p_bob', 'TR_audio')]);
      expect(find.text(l10n.roomMuted('Bob')), findsOneWidget);

      await tester.tap(find.byTooltip(l10n.roomOptionsFor('Bob')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomRemove));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomBanNote), findsOneWidget);
      await tester.tap(find.text(l10n.roomBan));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomRemoveConfirm));
      await tester.pumpAndSettle();
      expect(rooms.removals, [('p_bob', true)]);

      await tester.tap(find.text(l10n.inviteRotate));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.inviteRotateConfirm));
      await tester.pumpAndSettle();
      expect(rooms.rotateCalls, 1);
      final state =
          tester.element(find.byType(CallView)).read<RoomBloc>().state
              as RoomInCall;
      expect(state.room.code.value, 'zzzzzzzzzz');
    });

    testWidgets('controls stay visible while a screen reader is on', (
      tester,
    ) async {
      rooms.owner = false;
      await pumpRoom(tester, accessibleNavigation: true);
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, bob],
        ),
      );
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();

      expect(control(l10n.roomLeave).hitTestable(), findsOneWidget);
    });

    testWidgets('without a screen reader the controls hide after idle', (
      tester,
    ) async {
      await pumpRoom(tester);
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, bob],
        ),
      );
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();

      expect(control(l10n.roomLeave).hitTestable(), findsNothing);
    });

    testWidgets('Ctrl+D and Ctrl+E toggle microphone and camera', (
      tester,
    ) async {
      await pumpRoom(tester, size: const Size(1200, 800));
      await joinCall(tester);

      Future<void> chord(LogicalKeyboardKey key) async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyEvent(key);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pumpAndSettle();
      }

      await chord(LogicalKeyboardKey.keyD);
      expect(session().microphoneCommands, [false]);
      await chord(LogicalKeyboardKey.keyE);
      expect(session().cameraCommands, [false]);
      await chord(LogicalKeyboardKey.keyD);
      expect(session().microphoneCommands, [false, true]);
    });

    testWidgets('reconnecting shows a banner with Leave', (tester) async {
      await pumpRoom(tester);
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          connection: CallConnection.reconnecting,
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text(l10n.roomReconnecting), findsOneWidget);
      session().emit(FakeCallSession.connectedSnapshot);
      await tester.pump();
      await tester.pump();
      expect(find.text(l10n.roomReconnected), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  group('large text on a small phone (320x640, 200 %)', () {
    const small = Size(320, 640);

    testWidgets('lobby with password and host invite card', (tester) async {
      rooms
        ..owner = true
        ..lookupResult = sampleSummary(passwordRequired: true);
      preview.microphoneAccess = DeviceAccess.denied;
      await pumpRoom(tester, size: small, textScale: 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('lobby with a password and a countdown', (tester) async {
      rooms
        ..lookupResult = sampleSummary(passwordRequired: true)
        ..onJoin = (_, _) => Future.error(
          const TooManyAttemptsFailure(retryAfter: Duration(seconds: 90)),
        );
      await pumpRoom(tester, size: small, textScale: 2);
      await tester.enterText(
        find.widgetWithText(TextField, l10n.roomPasswordLabel),
        'guess',
      );
      await joinCall(tester);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 91));
    });

    testWidgets('call alone, 1:1 and grid, participants sheet', (tester) async {
      rooms
        ..owner = true
        ..onJoin = (_, _) async => sampleJoin(role: RoomRole.host);
      await pumpRoom(tester, size: small, textScale: 2);
      await joinCall(tester);
      expect(find.text(l10n.roomAlone), findsOneWidget);
      expect(tester.takeException(), isNull);

      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, bob],
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [
            localParticipant,
            bob,
            for (final n in ['Cid', 'Dee'])
              CallParticipant(
                id: 'PA_$n',
                identity: 'p_$n',
                displayName: n,
                isLocal: false,
              ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(control(l10n.roomParticipants));
      await tester.pumpAndSettle();
      expect(find.text(l10n.roomPeopleTitle(4)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ended and error screens', (tester) async {
      rooms.onJoin = (_, _) => Future.error(const RoomFullFailure());
      await pumpRoom(tester, size: small, textScale: 2);
      await joinCall(tester);
      expect(find.text(l10n.roomFullTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // Gate 3 findings (review3): each test fails without its fix.
  group('gate 3 regressions', () {
    Future<void> chord(WidgetTester tester, LogicalKeyboardKey key) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
    }

    Future<void> participantWithBob(WidgetTester tester, {Size? size}) async {
      await pumpRoom(tester, size: size ?? const Size(400, 800));
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, bob],
        ),
      );
      await tester.pumpAndSettle();
    }

    // CR3-5: a returning user (stored name) has the shortcuts at once.
    testWidgets('lobby: Ctrl+E works with a prefilled name', (tester) async {
      await pumpRoom(tester, size: const Size(1200, 800));
      expect(preview.state.cameraEnabled, isTrue);

      await chord(tester, LogicalKeyboardKey.keyE);

      expect(preview.state.cameraEnabled, isFalse);
    }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

    // CR3-1: while the preview releases the camera, nothing reopens it.
    testWidgets('lobby: device toggles are off from the Join tap on', (
      tester,
    ) async {
      await pumpRoom(tester, size: const Size(1200, 800));
      preview.pendingRelease = Completer<void>();

      await tester.tap(joinButton());
      await tester.pump();
      await chord(tester, LogicalKeyboardKey.keyE);
      await chord(tester, LogicalKeyboardKey.keyD);

      expect(preview.state.cameraEnabled, isTrue);
      expect(preview.state.microphoneEnabled, isTrue);
      preview.pendingRelease!.complete();
      await tester.pumpAndSettle();
      expect(session().connectedWith?.cameraEnabled, isTrue);
    }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

    testWidgets('lobby: the permission prompt hides while joining', (
      tester,
    ) async {
      preview
        ..cameraAccess = DeviceAccess.notAsked
        ..microphoneAccess = DeviceAccess.notAsked;
      rooms.pendingJoin = Completer();
      await pumpRoom(tester);
      expect(find.text(l10n.roomPermAllow), findsOneWidget);

      await tester.ensureVisible(joinButton());
      await tester.pumpAndSettle();
      await tester.tap(joinButton());
      await tester.pump();

      expect(find.text(l10n.roomPermAllow), findsNothing);
    });

    // SEC-23: the room password is never offered to a password manager.
    testWidgets('lobby: the password field has no autofill', (tester) async {
      rooms.lookupResult = sampleSummary(passwordRequired: true);
      await pumpRoom(tester);
      final field = tester.widget<TextField>(
        find.widgetWithText(TextField, l10n.roomPasswordLabel),
      );
      expect(field.autofillHints, isNull);
      expect(field.enableSuggestions, isFalse);
    });

    // UX3-04: the live region is announced once, not every second.
    testWidgets('lobby: the lock-out live region does not tick', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      rooms
        ..lookupResult = sampleSummary(passwordRequired: true)
        ..onJoin = (_, _) => Future.error(
          const TooManyAttemptsFailure(retryAfter: Duration(seconds: 5)),
        );
      await pumpRoom(tester);
      await tester.enterText(
        find.widgetWithText(TextField, l10n.roomPasswordLabel),
        'guess',
      );
      await joinCall(tester);

      String liveLabel() {
        final node = tester.getSemantics(
          find.bySemanticsLabel(RegExp('Too many attempts')),
        );
        expect(node.flagsCollection.isLiveRegion, isTrue);
        return node.label;
      }

      final first = liveLabel();
      await tester.pump(const Duration(seconds: 1));
      expect(liveLabel(), first);
      expect(find.text(l10n.roomTooManyAttempts('0:04')), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      semantics.dispose();
    });

    // UX3-03: system Back.
    testWidgets('Back in the lobby goes Home', (tester) async {
      await pumpRoom(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('at /'), findsOneWidget);
    });

    testWidgets('Back in a call: a participant leaves like with Leave', (
      tester,
    ) async {
      await participantWithBob(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(session().leaveCalls, greaterThan(0));
      expect(find.text(l10n.roomEndedLeft), findsOneWidget);
    });

    testWidgets('Back in a call: the host gets the leave sheet', (
      tester,
    ) async {
      await hostWithBob(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text(l10n.roomLeaveLeave), findsOneWidget);
      expect(session().leaveCalls, 0);
      await tester.tap(find.text(l10n.roomCancel));
      await tester.pumpAndSettle();
      expect(find.byType(CallView), findsOneWidget);
    });

    testWidgets('browser history: the exit guard runs the leave flow', (
      tester,
    ) async {
      final guard = RoomExitGuard();
      rooms
        ..owner = true
        ..onJoin = (_, _) async => sampleJoin(role: RoomRole.host);
      await pumpRoom(tester, exitGuard: guard);
      expect(await guard.mayExit(), isTrue, reason: 'lobby: leave at once');
      await joinCall(tester);

      final cancelled = guard.mayExit();
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomCancel));
      await tester.pumpAndSettle();
      expect(await cancelled, isFalse);

      final left = guard.mayExit();
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.roomLeaveLeave));
      await tester.pumpAndSettle();
      expect(await left, isTrue);
    });

    // CR3-4: the idle timer re-arms when hiding becomes possible.
    testWidgets('controls hide after the first guest joins a long wait', (
      tester,
    ) async {
      await pumpRoom(tester);
      await joinCall(tester);
      await tester.pump(const Duration(seconds: 5));
      expect(control(l10n.roomLeave).hitTestable(), findsOneWidget);

      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [localParticipant, bob],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(control(l10n.roomLeave).hitTestable(), findsNothing);
    });

    // UX3-01: never scaled below 48 dp, text never shrunk.
    for (final (size, scale) in [
      (const Size(600, 960), 2.0),
      (const Size(700, 900), 1.0),
      (const Size(320, 640), 1.0),
      (const Size(320, 640), 2.0),
    ]) {
      testWidgets('controls stay >= 48 dp at $size, ${scale * 100} %', (
        tester,
      ) async {
        rooms.onJoin = (_, _) async => sampleJoin(role: RoomRole.host);
        rooms.owner = true;
        await pumpRoom(tester, size: size, textScale: scale);
        await joinCall(tester);
        session().emit(
          FakeCallSession.connectedSnapshot.copyWith(
            participants: [localParticipant, bob],
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(FittedBox), findsNothing);
        final buttons = find.byType(MediaControlButton);
        expect(buttons, findsAtLeastNWidgets(5));
        for (final element in buttons.evaluate()) {
          final button = element.widget as MediaControlButton;
          expect(button.size, greaterThanOrEqualTo(48), reason: button.label);
          expect(
            tester.getSize(find.byWidget(button)).shortestSide,
            greaterThanOrEqualTo(48),
            reason: button.label,
          );
        }
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      });
    }

    testWidgets('call controls: localized names, toggle state, flip on touch', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await participantWithBob(tester);

      for (final label in [
        l10n.roomMic,
        l10n.roomCamera,
        l10n.roomFlip,
        l10n.roomLeave,
        l10n.roomInvite,
      ]) {
        expect(control(label), findsOneWidget, reason: label);
      }
      final mic = tester.getSemantics(
        find.descendant(
          of: control(l10n.roomMic),
          matching: find.bySemanticsLabel(l10n.roomMic),
        ),
      );
      expect(mic, isSemantics(hasToggledState: true, isToggled: true));

      await tester.tap(control(l10n.roomMic));
      await tester.pumpAndSettle();
      expect(session().microphoneCommands, [false]);
      semantics.dispose();
    });

    // UX3-02: a microphone that failed at join is explained in the call.
    testWidgets('call: an unavailable microphone shows a banner with retry', (
      tester,
    ) async {
      await pumpRoom(tester);
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          microphoneEnabled: false,
          microphoneUnavailable: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.roomMicUnavailable), findsOneWidget);
      await tester.tap(find.text(l10n.roomTryAgain));
      await tester.pumpAndSettle();
      expect(session().microphoneCommands, [true]);
    });

    // UX3-06: message and action say different things.
    testWidgets('call: the autoplay banner has its own action label', (
      tester,
    ) async {
      await pumpRoom(tester);
      await joinCall(tester);
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(audioPlaybackBlocked: true),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.roomSoundBlocked), findsOneWidget);
      await tester.tap(find.text(l10n.roomTurnOnSound));
      await tester.pumpAndSettle();
      expect(session().startAudioCalls, 1);
    });

    // UX3-08: Escape closes the participants dialog.
    testWidgets('call: Escape closes the participants dialog', (tester) async {
      await participantWithBob(tester, size: const Size(1280, 800));
      await tester.tap(control(l10n.roomParticipants));
      await tester.pumpAndSettle();
      expect(find.byType(ParticipantsPanel), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(ParticipantsPanel), findsNothing);
    });

    // UX3-09 / UX3-14: semantics of the count, the mic and the network.
    testWidgets('call: participants count, mic state and weak connection are '
        'spoken', (tester) async {
      final semantics = tester.ensureSemantics();
      await participantWithBob(tester, size: const Size(1280, 800));
      session().emit(
        FakeCallSession.connectedSnapshot.copyWith(
          participants: [
            localParticipant,
            const CallParticipant(
              id: 'PA_bob',
              identity: 'p_bob',
              displayName: 'Bob',
              isLocal: false,
              microphoneEnabled: true,
              weakConnection: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(
          '${l10n.roomParticipants}, ${l10n.roomParticipantCount(2)}',
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(l10n.roomWeakConnection)),
        findsOneWidget,
      );
      await tester.tap(control(l10n.roomParticipants));
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel(RegExp('Bob.*${l10n.roomMicOn}', dotAll: true)),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });
}
