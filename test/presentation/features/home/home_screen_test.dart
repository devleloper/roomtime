import 'dart:async';

import 'package:roomtime/core/router/app_routes.dart';
import 'package:roomtime/data/repositories/recent_rooms_repository.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/presentation/features/home/bloc/home_bloc.dart';
import 'package:roomtime/presentation/features/home/view/home_screen.dart';
import 'package:roomtime/presentation/features/home/widgets/home_desktop_layout.dart';
import 'package:roomtime/presentation/features/home/widgets/home_mobile_layout.dart';
import 'package:roomtime/presentation/widgets/custom_text_field.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/invite_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/fakes.dart';
import '../feature_harness.dart';
import 'package:roomtime/l10n/app_localizations.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

class FailingStore extends InMemoryKeyValueStore {
  bool failing = false;

  Future<void> _check() async {
    if (failing) throw const UnknownFailure(code: 'storage');
  }

  @override
  Future<void> write(String key, String value) async {
    await _check();
    await super.write(key, value);
  }

  @override
  Future<String?> read(String key) async {
    await _check();
    return super.read(key);
  }
}

void main() {
  late FakeRoomRepository rooms;
  late FailingStore store;

  setUp(() {
    rooms = FakeRoomRepository();
    store = FailingStore();
  });

  Future<GoRouter> pumpHome(
    WidgetTester tester, {
    Size size = const Size(400, 800),
    double textScale = 1,
    MediaPreview? preview,
    Locale locale = const Locale('en'),
  }) => pumpRouterApp(
    tester,
    locale: locale,
    size: size,
    textScale: textScale,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              HomeBloc(LocalRecentRoomsRepository(store), rooms)
                ..add(const HomeStarted()),
          child: HomeScreen(
            createPreview: preview == null ? null : () => preview,
          ),
        ),
      ),
      placeholderRoute('/r/:code'),
      placeholderRoute('/other'),
    ],
  );

  Finder joinField() => find.descendant(
    of: find.byType(CustomTextField),
    matching: find.byType(TextField),
  );

  Future<void> submit(WidgetTester tester, String input) async {
    await tester.enterText(joinField(), input);
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(l10n.homeJoin));
    await tester.pumpAndSettle();
  }

  Finder dialogButton(String label) =>
      find.byWidgetPredicate((w) => w is GlassDialogButton && w.label == label);

  Finder dialogField(String label) =>
      find.widgetWithText(TextField, label).last;

  Future<void> openCreate(WidgetTester tester) =>
      tapVisible(tester, find.text(l10n.homeCreateRoom));

  group('join field', () {
    testWidgets('a malformed code shows an inline error and sends nothing', (
      tester,
    ) async {
      await pumpHome(tester);

      await submit(tester, 'hello');

      expect(find.text(l10n.homeInvalidCode), findsOneWidget);
      expect(rooms.lookupCalls, 0);
    });

    testWidgets('a foreign link is not a room invite; no request', (
      tester,
    ) async {
      await pumpHome(tester);

      await submit(tester, 'https://example.com/watch?v=1');

      expect(find.text(l10n.homeNotARoomLink), findsOneWidget);
      expect(rooms.lookupCalls, 0);
    });

    testWidgets('Join is disabled while the field is empty', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpHome(tester);
      expect(
        tester.getSemantics(find.bySemanticsLabel(l10n.homeJoin)),
        isSemantics(isButton: true, hasEnabledState: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel(l10n.homeJoin)),
        isNot(isSemantics(isEnabled: true)),
      );
      await tester.tap(find.bySemanticsLabel(l10n.homeJoin));
      expect(rooms.lookupCalls, 0);
      semantics.dispose();
    });

    testWidgets('an error clears as soon as the code is edited', (
      tester,
    ) async {
      await pumpHome(tester);
      await submit(tester, 'hello');
      expect(find.text(l10n.homeInvalidCode), findsOneWidget);

      await tester.enterText(joinField(), 'hello2');
      await tester.pumpAndSettle();
      expect(find.text(l10n.homeInvalidCode), findsNothing);
    });

    testWidgets('a valid link looks the room up and opens the lobby', (
      tester,
    ) async {
      await pumpHome(tester);

      await submit(tester, 'https://calls.test/r/ABC-DEFG-HJK');

      expect(rooms.lookupCalls, 1);
      expect(find.text('at /r/abcdefghjk'), findsOneWidget);
    });

    testWidgets('the keyboard Go action joins', (tester) async {
      await pumpHome(tester);

      await tester.enterText(joinField(), 'abc-defg-hjk');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();

      expect(rooms.lookupCalls, 1);
      expect(find.text('at /r/abcdefghjk'), findsOneWidget);
    });

    testWidgets('an error brings the focus back to the field', (tester) async {
      await pumpHome(tester);

      await submit(tester, 'hello');

      expect(find.text(l10n.homeInvalidCode), findsOneWidget);
      final field = tester.widget<TextField>(joinField());
      expect(field.focusNode?.hasFocus, isTrue);
      expect(field.textInputAction, TextInputAction.go);
    });

    testWidgets('lookup failure stays inline on Home', (tester) async {
      rooms.lookupResult = const RoomNotFoundFailure();
      await pumpHome(tester);

      await submit(tester, 'abc-defg-hjk');

      expect(find.textContaining('Room not found'), findsOneWidget);
      expect(find.text('at /r/abcdefghjk'), findsNothing);
    });
  });

  group('new room', () {
    testWidgets('create dialog -> invite step with code, link and Join', (
      tester,
    ) async {
      await pumpHome(tester);

      await openCreate(tester);
      expect(find.byType(GlassPanel), findsOneWidget);
      expect(dialogButton(l10n.homeCancel), findsOneWidget);
      await tester.enterText(dialogField(l10n.homeCreateNameLabel), 'Family');
      await tester.tap(dialogButton(l10n.homeCreate));
      await tester.pumpAndSettle();

      expect(rooms.createCalls, 1);
      expect(rooms.createdWith?.name, 'Family');
      expect(rooms.createdWith?.password, isNull);
      expect(rooms.createdWith?.lifetimeMinutes, isNull);
      expect(rooms.createdWith?.maxParticipants, isNull);
      expect(find.text(l10n.inviteReady), findsOneWidget);
      final panel = find.byType(InvitePanel);
      expect(
        find.descendant(of: panel, matching: find.text('abc-defg-hjk')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: panel,
          matching: find.text('https://calls.test/r/abc-defg-hjk'),
        ),
        findsOneWidget,
      );

      expect(dialogButton(l10n.inviteCopyLink), findsOneWidget);
      expect(dialogButton(l10n.inviteCopyCode), findsOneWidget);
      expect(dialogButton(l10n.inviteShare), findsOneWidget);

      await tester.tap(dialogButton(l10n.homeJoin));
      await tester.pumpAndSettle();
      expect(find.text('at /r/abcdefghjk'), findsOneWidget);
    });

    testWidgets('a too short password is rejected before any request', (
      tester,
    ) async {
      await pumpHome(tester);
      await openCreate(tester);
      await tester.enterText(dialogField(l10n.homePasswordOptional), 'abc');
      await tester.tap(dialogButton(l10n.homeCreate));
      await tester.pumpAndSettle();

      expect(find.text(l10n.homeCreatePasswordTooShort), findsOneWidget);
      expect(rooms.createCalls, 0);
    });

    testWidgets('the room password is sent verbatim, not trimmed', (
      tester,
    ) async {
      await pumpHome(tester);
      await openCreate(tester);
      await tester.enterText(
        dialogField(l10n.homePasswordOptional),
        '  Pa ss  ',
      );
      await tester.tap(dialogButton(l10n.homeCreate));
      await tester.pumpAndSettle();

      expect(rooms.createCalls, 1);
      expect(rooms.createdWith?.password, '  Pa ss  ');
    });

    testWidgets('the dialog asks only for a name and a password', (
      tester,
    ) async {
      await pumpHome(tester);
      await openCreate(tester);

      expect(find.textContaining('ncryption'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(GlassPanel),
          matching: find.byType(TextField),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('Cancel closes the dialog without a request', (tester) async {
      await pumpHome(tester);
      await openCreate(tester);
      await tester.tap(dialogButton(l10n.homeCancel));
      await tester.pumpAndSettle();
      expect(find.byType(GlassPanel), findsNothing);
      expect(rooms.createCalls, 0);
    });

    testWidgets('a create failure shows the human message and Retry', (
      tester,
    ) async {
      rooms.createResult = const NetworkFailure();
      await pumpHome(tester);
      await openCreate(tester);
      await tester.tap(dialogButton(l10n.homeCreate));
      await tester.pumpAndSettle();

      expect(find.text(l10n.failureNetwork), findsOneWidget);
      expect(dialogButton(l10n.homeCreateRetry), findsOneWidget);
      expect(find.text(l10n.inviteReady), findsNothing);
    });
  });

  group('recent rooms', () {
    Future<void> seed() async {
      final recents = LocalRecentRoomsRepository(store);
      await recents.record(
        RecentRoom(
          code: testCode,
          name: 'Family',
          role: RoomRole.participant,
          lastJoined: DateTime.utc(2026, 11, 1),
        ),
      );
      await recents.record(
        RecentRoom(
          code: RoomCode.tryParse('mnpqrstuvw')!,
          name: 'Work',
          role: RoomRole.host,
          lastJoined: DateTime.utc(2026, 11, 2),
        ),
      );
    }

    testWidgets('Remove offers Undo, which restores the row', (tester) async {
      await seed();
      await pumpHome(tester);
      expect(find.text('Family'), findsOneWidget);

      await tapVisible(
        tester,
        find.byTooltip(l10n.homeRecentRemoveFor('Family')),
      );
      expect(find.text('Family'), findsNothing);
      expect(find.text(l10n.homeRecentRemoved), findsOneWidget);

      await tester.tap(find.text(l10n.homeUndo));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Work')).dy,
        lessThan(tester.getTopLeft(find.text('Family')).dy),
      );
    });

    testWidgets('leaving Home hides the Undo SnackBar', (tester) async {
      await seed();
      final router = await pumpHome(tester);
      await tapVisible(
        tester,
        find.byTooltip(l10n.homeRecentRemoveFor('Family')),
      );
      expect(find.text(l10n.homeUndo), findsOneWidget);

      router.go('/other');
      await tester.pumpAndSettle();

      expect(find.text(l10n.homeUndo), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a storage failure on remove keeps the list', (tester) async {
      await seed();
      await pumpHome(tester);
      store.failing = true;

      await tapVisible(
        tester,
        find.byTooltip(l10n.homeRecentRemoveFor('Family')),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Family'), findsOneWidget);
    });

    testWidgets('a row opens the lobby of that room', (tester) async {
      await seed();
      await pumpHome(tester);
      await tapVisible(tester, find.text('Family'));
      expect(find.text('at /r/abcdefghjk'), findsOneWidget);
    });
  });

  group('Russian locale', () {
    final ru = lookupAppLocalizations(const Locale('ru'));

    testWidgets('home renders in Russian', (tester) async {
      await pumpHome(tester, locale: const Locale('ru'));
      await tester.pumpAndSettle();
      expect(find.text(ru.homeCreateRoom), findsOneWidget);
      expect(find.text(ru.homeJoinWithCode), findsOneWidget);
      expect(find.text(ru.homeRecent), findsOneWidget);
      expect(find.text(l10n.homeCreateRoom), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('long Russian text fits a small phone at 200 %', (
      tester,
    ) async {
      await pumpHome(
        tester,
        locale: const Locale('ru'),
        size: const Size(320, 640),
        textScale: 2,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('large text on a small phone (320x640, 200 %)', () {
    const small = Size(320, 640);

    testWidgets('home', (tester) async {
      await pumpHome(tester, size: small, textScale: 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('create dialog and invite step', (tester) async {
      await pumpHome(tester, size: small, textScale: 2);
      await openCreate(tester);
      expect(tester.takeException(), isNull);

      await tester.enterText(dialogField(l10n.homePasswordOptional), 'secret');
      await tapVisible(tester, dialogButton(l10n.homeCreate));
      expect(find.text(l10n.inviteReady), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('phone: the full-screen veil layout', (tester) async {
      await pumpHome(tester);
      expect(find.byType(HomeMobileLayout), findsOneWidget);
    });

    testWidgets('wide: the 380 dp sidebar, camera on the right', (
      tester,
    ) async {
      await pumpHome(tester, size: const Size(1200, 800));
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeDesktopLayout), findsOneWidget);
      expect(
        tester.getSize(find.byType(LiquidGlassContainer).first).width,
        380,
      );
    });
  });

  group('camera backdrop', () {
    testWidgets('never prompts on Home; offers a button instead', (
      tester,
    ) async {
      final preview = FakeMediaPreview()..cameraAccess = DeviceAccess.notAsked;
      await pumpHome(tester, preview: preview);
      await tester.pumpAndSettle();

      expect(preview.requestCalls, 0);
      expect(preview.state.cameraEnabled, isFalse);
      final toggle = find.bySemanticsLabel(l10n.homeCameraPreview);
      expect(toggle, findsOneWidget);
      expect(
        tester.getSemantics(toggle),
        isSemantics(hasToggledState: true, isToggled: false),
      );

      await tapVisible(tester, toggle);
      expect(preview.requestCalls, 1);
      expect(preview.state.cameraEnabled, isTrue);
    });

    testWidgets('starts with granted access, stops when a route covers it', (
      tester,
    ) async {
      final preview = FakeMediaPreview();
      final router = await pumpHome(tester, preview: preview);
      await tester.pumpAndSettle();
      expect(preview.state.cameraEnabled, isTrue);

      unawaited(router.push('/other'));
      await tester.pumpAndSettle();
      expect(preview.releaseCalls, 1);

      final starts = preview.startCalls;
      router.pop();
      await tester.pumpAndSettle();
      expect(preview.startCalls, starts + 1);
    });

    testWidgets('the camera button turns a running preview off', (
      tester,
    ) async {
      final preview = FakeMediaPreview();
      await pumpHome(tester, preview: preview);
      await tester.pumpAndSettle();
      expect(preview.state.cameraEnabled, isTrue);

      await tapVisible(tester, find.bySemanticsLabel(l10n.homeCameraPreview));
      expect(preview.releaseCalls, 1);
    });

    testWidgets('denied access: no camera button, black backdrop', (
      tester,
    ) async {
      final preview = FakeMediaPreview()..cameraAccess = DeviceAccess.denied;
      await pumpHome(tester, preview: preview);
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(l10n.homeCameraPreview), findsNothing);
      expect(preview.requestCalls, 0);
    });

    testWidgets('stops in the background and when Home is disposed', (
      tester,
    ) async {
      final preview = FakeMediaPreview();
      await pumpHome(tester, preview: preview);
      await tester.pumpAndSettle();

      final binding = tester.binding;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pump();
      expect(preview.releaseCalls, 1);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(preview.state.cameraEnabled, isTrue);

      await tester.pumpWidget(const SizedBox());
      expect(preview.disposeCalls, 1);
    });
  });

  group('malformed invite link', () {
    late PendingHomeNotice notices;
    var roomBuilds = 0;

    setUp(() {
      notices = PendingHomeNotice();
      roomBuilds = 0;
    });

    Future<GoRouter> pumpApp(WidgetTester tester, String location) =>
        pumpRouterApp(
          tester,
          location: location,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                create: (_) =>
                    HomeBloc(LocalRecentRoomsRepository(store), rooms)
                      ..add(const HomeStarted()),
                child: HomeScreen(notices: notices),
              ),
            ),
            GoRoute(
              path: AppRoutes.roomPattern,
              redirect: (context, state) => AppRoutes.roomRedirect(
                state.pathParameters['code'] ?? '',
                notices,
              ),
              builder: (context, state) {
                roomBuilds++;
                return const Text('room');
              },
            ),
          ],
        );

    testWidgets('a cold deep link shows Home at once, then the notice', (
      tester,
    ) async {
      final router = await pumpApp(tester, '/r/zz');

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(roomBuilds, 0);
      expect(router.state.uri.path, AppRoutes.home);

      await tester.pumpAndSettle();
      expect(find.text(l10n.homeInvalidInviteLink), findsOneWidget);
      expect(notices.take(), isNull, reason: 'one-shot');
    });

    testWidgets('a bad link opened while Home is up shows the notice', (
      tester,
    ) async {
      final router = await pumpApp(tester, '/');
      await tester.pumpAndSettle();
      expect(find.text(l10n.homeInvalidInviteLink), findsNothing);

      router.go('/r/zz');
      await tester.pumpAndSettle();

      expect(find.text(l10n.homeInvalidInviteLink), findsOneWidget);
      expect(roomBuilds, 0);
    });

    testWidgets('a valid link still opens the room, no notice', (tester) async {
      await pumpApp(tester, '/r/ABC-DEFG-HJK');
      await tester.pumpAndSettle();

      expect(find.text('room'), findsOneWidget);
      expect(find.text(l10n.homeInvalidInviteLink), findsNothing);
    });
  });
}
