import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/presentation/features/room/widgets/call_video_layout.dart';

import '../../../helpers/fakes.dart';

// a removal drops the others before the room disconnect arrives;
// the invite card must not flash "alone" in between.
void main() {
  Widget layout(List<CallParticipant> people) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: CallVideoLayout(
        call: CallSnapshot(
          connection: CallConnection.connected,
          participants: people,
        ),
        isHost: false,
        onBackgroundTap: () {},
        aloneOverlay: const Text('alone card'),
      ),
    ),
  );

  testWidgets('joining an empty room shows the card at once', (tester) async {
    await tester.pumpWidget(layout(const [localParticipant]));
    expect(find.text('alone card'), findsOneWidget);
  });

  testWidgets('the others leaving shows the card only after the grace', (
    tester,
  ) async {
    await tester.pumpWidget(
      layout(const [localParticipant, remoteParticipant]),
    );
    await tester.pumpWidget(layout(const [localParticipant]));
    expect(find.text('alone card'), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('alone card'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('alone card'), findsOneWidget);
  });

  testWidgets('someone coming back cancels the pending card', (tester) async {
    await tester.pumpWidget(
      layout(const [localParticipant, remoteParticipant]),
    );
    await tester.pumpWidget(layout(const [localParticipant]));
    await tester.pumpWidget(
      layout(const [localParticipant, remoteParticipant]),
    );
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('alone card'), findsNothing);
  });
}
