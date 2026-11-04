import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/presentation/invite/invite_sharing.dart';
import 'package:roomtime/presentation/utils/failure_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:roomtime/l10n/app_localizations.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

// CR3-6.
void main() {
  const unavailable = ShareResult.unavailable;

  test('web: a share that returned is finished, even as "unavailable"', () {
    expect(shareFinished(unavailable, web: true), isTrue);
  });

  test('native: "unavailable" falls back to copying', () {
    expect(shareFinished(unavailable, web: false), isFalse);
    expect(
      shareFinished(
        const ShareResult('x', ShareResultStatus.success),
        web: false,
      ),
      isTrue,
    );
  });

  testWidgets('a refused clipboard shows no "copied" and throws nothing', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.setData'
          ? throw PlatformException(code: 'copy_fail')
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => copyWithConfirmation(context, 'link', 'Copied'),
              child: const Text('copy'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('copy'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Copied'), findsNothing);
  });

  // UX3-10: a refused media connection gets the spec's text.
  // CR-1: the second copy lands before the first pill was built.
  testWidgets('two copies in one frame leave one pill, gone after the '
      'timeout', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox.expand();
          },
        ),
      ),
    );

    await Future.wait([
      copyWithConfirmation(context, 'a', 'Copied'),
      copyWithConfirmation(context, 'b', 'Copied'),
    ]);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Copied'), findsOneWidget);

    await tester.pump(copiedHudDuration);
    await tester.pump();
    expect(find.text('Copied'), findsNothing);
  });

  test('media_refused reads as a connection problem', () {
    expect(
      const UnknownFailure(code: 'media_refused').localizedMessage(l10n),
      startsWith("Couldn't connect to the call"),
    );
    expect(
      const UnknownFailure().localizedMessage(l10n),
      startsWith('Something went wrong'),
    );
  });
}
