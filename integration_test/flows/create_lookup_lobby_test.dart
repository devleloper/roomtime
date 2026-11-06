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
    await tapWhenHittable(tester, find.text(l10n.homeCreateRoom));
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
    await tapWhenHittable(tester, find.text(l10n.homeCreate));
    await pumpUntilFound(tester, find.text(l10n.inviteReady));
    return readShownRoomCode(tester);
  }

  Future<void> lookUpFromHome(WidgetTester tester, String code) async {
    final l10n = l10nOf(tester);
    await tapWhenHittable(tester, find.text(l10n.inviteDone));
    await pumpUntilGone(tester, find.text(l10n.inviteReady));
    await tester.enterText(
      find.widgetWithText(TextField, l10n.homeJoinLabel),
      code,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tapWhenHittable(tester, find.text(l10n.homeJoin));
  }

  testWidgets('create-lookup-lobby: open room opens the lobby by code', (
    tester,
  ) async {
    await launchApp(tester);
    final name = 'QA open ${DateTime.now().millisecondsSinceEpoch % 100000}';
    final code = await createRoom(tester, name: name);

    await lookUpFromHome(tester, code);
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

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
    await launchApp(tester);
    final code = await createRoom(
      tester,
      name: 'QA locked',
      password: 'qa-pass-1',
    );

    await lookUpFromHome(tester, code);
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

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
    final code = await createRoomViaApi(
      name: 'QA guest locked',
      password: 'qa-pass-2',
    );
    await launchApp(tester);

    await tester.enterText(
      find.widgetWithText(TextField, l10nOf(tester).homeJoinLabel),
      code,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tapWhenHittable(tester, find.text(l10nOf(tester).homeJoin));
    await pumpUntilFound(tester, find.text(l10nOf(tester).roomJoin));

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
    await launchApp(tester);

    await tester.enterText(
      find.widgetWithText(TextField, l10nOf(tester).homeJoinLabel),
      'zzz-zzzz-zzz',
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tapWhenHittable(tester, find.text(l10nOf(tester).homeJoin));
    await pumpUntilFound(
      tester,
      find.textContaining(l10nOf(tester).roomNotFoundTitle),
    );

    expect(find.text(l10nOf(tester).roomJoin), findsNothing);
    expectNoRawErrors();
  });
}
