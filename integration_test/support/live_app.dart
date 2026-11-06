import 'dart:convert';
import 'dart:io';

import 'package:roomtime/core/di/injection.dart';
import 'package:roomtime/core/router/app_router.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

bool _dependenciesReady = false;

Future<void> launchApp(WidgetTester tester) async {
  if (!_dependenciesReady) {
    configureDependencies();
    _dependenciesReady = true;
  }
  await tester.pumpWidget(const SizedBox.shrink());
  appRouter.go('/');
  await tester.pumpWidget(const RoomTimeApp());
  await pumpUntilFound(tester, find.byType(Scaffold));
  await pumpUntilFound(tester, find.text(l10nOf(tester).homeCreateRoom));
}

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first));

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

/// Taps [finder] once its centre hit-tests to it: dialogs, sheets and the
/// on-screen keyboard animate, so a tap right after they appear can land on
/// the widget underneath.
Future<void> tapWhenHittable(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final hittable = finder.hitTestable();
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    if (hittable.evaluate().isNotEmpty) {
      await tester.tap(hittable.first);
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  throw TestFailure('Timed out after $timeout waiting to tap $finder');
}

final RegExp roomCodePattern = RegExp(
  r'^[a-hjkmnp-z]{3}-[a-hjkmnp-z]{4}-[a-hjkmnp-z]{3}$',
);

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

void expectNoRawErrors() {
  for (final pattern in ['Exception', 'Error:', 'DioException', '#0 ']) {
    expect(find.textContaining(pattern), findsNothing, reason: pattern);
  }
}

const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

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
