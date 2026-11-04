import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/presentation/dialogs/glass_dialog.dart';

// QA D5: a label never breaks inside a word; the row stacks instead.
void main() {
  Future<void> pumpRow(
    WidgetTester tester,
    double width,
    String a, [
    String b = 'Поделиться…',
  ]) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: GlassButtonRow(
              children: [
                GlassDialogButton(label: a, icon: Icons.link, onPressed: () {}),
                GlassDialogButton(
                  label: b,
                  icon: Icons.ios_share,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  /// The second button starts below the first one.
  bool stacked(
    WidgetTester tester,
    String first, [
    String second = 'Поделиться…',
  ]) =>
      tester.getTopLeft(find.text(second)).dy >
      tester.getBottomLeft(find.text(first)).dy;

  testWidgets('narrow: long Russian words stack the buttons', (tester) async {
    await pumpRow(tester, 280, 'Скопировать ссылку');
    expect(stacked(tester, 'Скопировать ссылку'), isTrue);
  });

  testWidgets('wide enough: side by side', (tester) async {
    await pumpRow(tester, 600, 'Скопировать ссылку');
    expect(stacked(tester, 'Скопировать ссылку'), isFalse);
  });

  testWidgets('short English labels stay side by side on a phone', (
    tester,
  ) async {
    // The test font draws every glyph 1 em wide.
    await pumpRow(tester, 320, 'Copy', 'Share');
    expect(stacked(tester, 'Copy', 'Share'), isFalse);
  });
}
