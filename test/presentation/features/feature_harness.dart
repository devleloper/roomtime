import 'dart:async';

import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pumps a router app with [routes] at [location], like the real app but
/// with test MediaQuery settings.
Future<GoRouter> pumpRouterApp(
  WidgetTester tester, {
  required List<RouteBase> routes,
  String location = '/',
  Size size = const Size(400, 800),
  double textScale = 1,
  bool accessibleNavigation = false,
  Locale locale = const Locale('en'),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final router = GoRouter(initialLocation: location, routes: routes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // As in main.dart: dark-only.
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          accessibleNavigation: accessibleNavigation,
        ),
        child: child!,
      ),
    ),
  );
  await tester.pump();
  return router;
}

/// Placeholder destination that shows where navigation went.
GoRoute placeholderRoute(String path) => GoRoute(
  path: path,
  builder: (context, state) => Scaffold(body: Text('at ${state.uri.path}')),
);

/// In-memory [MediaPreview]: records calls, no devices.
class FakeMediaPreview implements MediaPreview {
  final _states = StreamController<MediaPreviewState>.broadcast(sync: true);
  MediaPreviewState _state = const MediaPreviewState();
  int startCalls = 0;
  int releaseCalls = 0;
  int disposeCalls = 0;
  int requestCalls = 0;
  int refreshCalls = 0;

  /// Access reported on start (e.g. denied camera).
  DeviceAccess cameraAccess = DeviceAccess.granted;
  DeviceAccess microphoneAccess = DeviceAccess.granted;

  void _set(MediaPreviewState next) {
    _state = next;
    if (!_states.isClosed) _states.add(next);
  }

  @override
  Stream<MediaPreviewState> get states => _states.stream;

  @override
  MediaPreviewState get state => _state;

  @override
  bool get canOpenSettings => false;

  @override
  Future<void> start({required bool camera, required bool microphone}) async {
    startCalls++;
    _set(
      _state.copyWith(
        cameraEnabled: camera,
        microphoneEnabled: microphone,
        cameraAccess: cameraAccess,
        microphoneAccess: microphoneAccess,
      ),
    );
  }

  @override
  Future<void> requestAccess() async => requestCalls++;

  @override
  Future<void> refreshAccess() async => refreshCalls++;

  @override
  Future<void> setCameraEnabled(bool enabled) async =>
      _set(_state.copyWith(cameraEnabled: enabled));

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async =>
      _set(_state.copyWith(microphoneEnabled: enabled));

  @override
  Future<void> openSettings() async {}

  /// Holds [release] open, like a camera that takes time to stop.
  Completer<void>? pendingRelease;

  @override
  Future<void> release() async {
    releaseCalls++;
    await pendingRelease?.future;
  }

  @override
  Future<void> dispose() async {
    disposeCalls++;
    await _states.close();
  }
}

/// Scrolls [finder] into view (large text pushes things down), then taps.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
