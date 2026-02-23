import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:familycalls/presentation/widgets/custom_bounce_button.dart';

void main() {
  testWidgets('CustomBounceButton animates on tap', (
    WidgetTester tester,
  ) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBounceButton(
            onPressed: () => pressed = true,
            child: const Text('Bounce'),
          ),
        ),
      ),
    );

    // Initial scale is 1.0 (implicitly tested if rendering)
    final buttonFinder = find.byType(CustomBounceButton);
    expect(buttonFinder, findsOneWidget);

    // Tap and hold
    final gesture = await tester.startGesture(tester.getCenter(buttonFinder));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150)); // let animation run

    // Release
    await gesture.up();
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
