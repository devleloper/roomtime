// Create -> lookup -> lobby against a running backend (no mocks).
//
// flutter test integration_test/flows/create_lookup_lobby_test.dart \
//   -d <device> --dart-define-from-file=config/local.example.json

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../support/live_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<String> createRoom(
    WidgetTester tester, {
    required String name,
    String? password,
  }) async {
    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.homeCreateRoom));
    await pumpUntilFound(tester, find.text(l10n.homeCreate));
    await tester.enterText(
      find.widgetWithText(TextField, l10n.homeCreateNameLabel),
      name,
    );
    if (password != null) {
      await tester.enterText(
        find.widgetWithText(TextField, l10n.homePasswordOptional),
        password,
      );
    }
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(l10n.homeCreate));
    await pumpUntilFound(tester, find.text(l10n.inviteReady));
    return readShownRoomCode(tester);
  }

  Future<void> lookUpFromHome(WidgetTester tester, String code) async {
    // Close the "Your room is ready" sheet and stay on Home.
    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.inviteDone));
    await pumpUntilGone(tester, find.text(l10n.inviteReady));
    await tester.enterText(
      find.widgetWithText(TextField, l10n.homeJoinLabel),
      code,
    );
    // Let the Join button rebuild as enabled before tapping it.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(l10n.homeJoin));
  }

  testWidgets('create-lookup-lobby: open room opens the lobby by code', (
    tester,
  ) async {
    // Arrange
    await launchApp(tester);
    final name = 'QA open ${DateTime.now().millisecondsSinceEpoch % 100000}';
    final code = await createRoom(tester, name: name);

    // Act
    await lookUpFromHome(tester, code);
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

    // Assert
    expect(find.text(name), findsWidgets);
    expect(
      find.widgetWithText(TextField, l10nOf(tester).roomPasswordLabel),
      findsNothing,
    );
    expectNoRawErrors();
  });

  testWidgets('create-lookup-lobby: host of a password room skips it', (
    tester,
  ) async {
    // Arrange
    await launchApp(tester);
    final code = await createRoom(
      tester,
      name: 'QA locked',
      password: 'qa-pass-1',
    );

    // Act
    await lookUpFromHome(tester, code);
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

    // Assert: the owner token on this install makes it the host.
    expect(find.text(l10nOf(tester).roomHostNotice), findsOneWidget);
    expect(
      find.widgetWithText(TextField, l10nOf(tester).roomPasswordLabel),
      findsNothing,
    );
    expectNoRawErrors();
  });

  testWidgets('create-lookup-lobby: guest lobby asks for the password', (
    tester,
  ) async {
    // Arrange: another client creates the room through the public API.
    final code = await createRoomViaApi(
      name: 'QA guest locked',
      password: 'qa-pass-2',
    );
    await launchApp(tester);

    // Act
    await tester.enterText(
      find.widgetWithText(TextField, l10nOf(tester).homeJoinLabel),
      code,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(l10nOf(tester).homeJoin));
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

    // Assert: password field shown, the name stays hidden.
    expect(
      find.widgetWithText(TextField, l10nOf(tester).roomPasswordLabel),
      findsOneWidget,
    );
    expect(find.text('QA guest locked'), findsNothing);
    expectNoRawErrors();
  });

  testWidgets('create-lookup-lobby: unknown code shows room not found', (
    tester,
  ) async {
    // Arrange
    await launchApp(tester);

    // Act
    await tester.enterText(
      find.widgetWithText(TextField, l10nOf(tester).homeJoinLabel),
      'zzz-zzzz-zzz',
    );
    // Let the Join button rebuild as enabled before tapping it.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(l10nOf(tester).homeJoin));
    await pumpUntilFound(
      tester,
      find.textContaining(l10nOf(tester).roomNotFoundTitle),
    );

    // Assert
    expect(find.text(l10nOf(tester).roomJoin), findsNothing);
    expectNoRawErrors();
  });
}
