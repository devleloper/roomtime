import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
  double textScale = 1,
  bool disableAnimations = false,
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    setWindowSize(tester, surfaceSize);
  }
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.dark,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: disableAnimations,
          ),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    ),
  );
}

Future<void> tab(WidgetTester tester, {int times = 1}) async {
  for (var i = 0; i < times; i++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }
}

void setWindowSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}
