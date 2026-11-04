// Launch and finder helpers for integration tests that run the real app
// against the local compose stack (docs/ops/local-stack.md).
//
// Build with `--dart-define-from-file=config/local.example.json`; on Android
// run `make android-reverse` first so the emulator reaches localhost:8080.

import 'dart:convert';
import 'dart:io';

import 'package:roomtime/app/app_router.dart';
import 'package:roomtime/core/di/injection.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

bool _dependenciesReady = false;

/// Starts the app on Home. DI is configured once per test process; the
/// router is reset to `/` so every test starts from the same screen.
Future<void> launchApp(WidgetTester tester) async {
  if (!_dependenciesReady) {
    configureDependencies();
    _dependenciesReady = true;
  }
  // Unmount the previous app so open sheets and routes do not leak between
  // tests, then start again on Home.
  await tester.pumpWidget(const SizedBox.shrink());
  appRouter.go('/');
  await tester.pumpWidget(const RoomTimeApp());
  await pumpUntilFound(tester, find.byType(Scaffold));
  await pumpUntilFound(tester, find.text(l10nOf(tester).homeCreateRoom));
}

/// Strings in the device language: finders never hard-code English, so the
/// suite runs on simulators set to any shipped locale (en, ru).
AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first));

/// Pumps frames until [finder] matches or [timeout] passes. Network calls to
/// the live stack make `pumpAndSettle` unsuitable (spinners never settle).
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out after $timeout waiting for $finder');
}

/// Pumps frames until [finder] no longer matches or [timeout] passes.
Future<void> pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isEmpty) return;
  }
  throw TestFailure('Timed out after $timeout waiting for $finder to go');
}

/// Matches a displayed room code such as `abc-defg-hjk` (ADR-0003 alphabet).
final RegExp roomCodePattern = RegExp(
  r'^[a-hjkmnp-z]{3}-[a-hjkmnp-z]{4}-[a-hjkmnp-z]{3}$',
);

/// The room code shown on the host's "Your room is ready" card.
String readShownRoomCode(WidgetTester tester) {
  final codes = tester
      .widgetList<SelectableText>(find.byType(SelectableText))
      .map((w) => w.data ?? '')
      .where(roomCodePattern.hasMatch)
      .toSet();
  if (codes.length != 1) {
    throw TestFailure('Expected one room code on screen, found $codes');
  }
  return codes.single;
}

/// No raw exception or stack text is visible.
void expectNoRawErrors() {
  for (final pattern in ['Exception', 'Error:', 'DioException', '#0 ']) {
    expect(find.textContaining(pattern), findsNothing, reason: pattern);
  }
}

/// API origin the app was built with (`config/local.example.json`).
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// Creates a room as an independent client (plain HTTP, no app code) and
/// returns its code, so the app under test is a guest, not the host.
Future<String> createRoomViaApi({String? name, String? password}) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse('$apiBaseUrl/v1/rooms'));
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'name': name, 'password': password}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 201) {
      throw TestFailure('POST /v1/rooms -> ${response.statusCode}');
    }
    return (jsonDecode(body) as Map<String, Object?>)['code']! as String;
  } finally {
    client.close();
  }
}
