import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/presentation/features/room/view/ended_view.dart';
import 'package:roomtime/presentation/features/room/view/join_error_view.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/l10n/app_localizations.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

void main() {
  late List<String> taps;

  setUp(() => taps = []);

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(400, 800),
    double textScale = 1,
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child,
          ),
        ),
      ),
    );
  }

  EndedView ended(CallEndReason reason, {bool byYou = false}) => EndedView(
    reason: reason,
    endedByYou: byYou,
    onRejoin: () => taps.add('rejoin'),
    onHome: () => taps.add('home'),
    onNewRoom: () => taps.add('new'),
  );

  final cases = <(CallEndReason, bool), (String, List<String>)>{
    (CallEndReason.left, false): (
      l10n.roomEndedLeft,
      [l10n.roomRejoin, l10n.roomHome],
    ),
    (CallEndReason.endedByHost, false): (l10n.roomEndedByHost, [l10n.roomHome]),
    (CallEndReason.endedByHost, true): (
      l10n.roomEndedByYou,
      [l10n.roomHome, l10n.roomNewRoom],
    ),
    (CallEndReason.removed, false): (l10n.roomEndedRemoved, [l10n.roomHome]),
    (CallEndReason.roomDeleted, false): (
      l10n.roomEndedExpired,
      [l10n.roomHome, l10n.roomNewRoom],
    ),
    (CallEndReason.joinedElsewhere, false): (
      l10n.roomEndedElsewhere,
      [l10n.roomHome, l10n.roomUseHere],
    ),
    (CallEndReason.connectionLost, false): (
      l10n.roomEndedConnectionLost,
      [l10n.roomRejoin, l10n.roomHome],
    ),
  };

  final allButtons = [
    l10n.roomRejoin,
    l10n.roomHome,
    l10n.roomNewRoom,
    l10n.roomUseHere,
  ];

  for (final MapEntry(key: (reason, byYou), value: (title, buttons))
      in cases.entries) {
    testWidgets('ended: ${reason.name}${byYou ? ' (by you)' : ''}', (
      tester,
    ) async {
      await pump(tester, ended(reason, byYou: byYou));

      expect(find.text(title), findsOneWidget);
      for (final label in allButtons) {
        expect(
          find.text(label),
          buttons.contains(label) ? findsOneWidget : findsNothing,
          reason: label,
        );
      }
    });

    testWidgets('ended at 200 % on 320x640: ${reason.name}', (tester) async {
      await pump(
        tester,
        ended(reason, byYou: byYou),
        size: const Size(320, 640),
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Rejoin and Home call back', (tester) async {
    await pump(tester, ended(CallEndReason.connectionLost));
    await tester.tap(find.text(l10n.roomRejoin));
    await tester.tap(find.text(l10n.roomHome));
    expect(taps, ['rejoin', 'home']);
  });

  testWidgets('join errors at 200 % on 320x640', (tester) async {
    for (final failure in const <Failure>[
      RoomNotFoundFailure(),
      RoomFullFailure(),
      RoomLockedFailure(),
      ParticipantBannedFailure(),
      NetworkFailure(),
    ]) {
      await pump(
        tester,
        JoinErrorView(
          failure: failure,
          onHome: () {},
          onRetry: () {},
          maxParticipants: 6,
        ),
        size: const Size(320, 640),
        textScale: 2,
      );
      expect(tester.takeException(), isNull, reason: '$failure');
    }
  });
}
