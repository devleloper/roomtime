import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/app_localizations.dart';
import 'package:roomtime/presentation/dialogs/glass_dialog.dart';
import 'package:roomtime/presentation/features/room/widgets/call_notice.dart';
import 'package:roomtime/presentation/features/room/widgets/media_controls.dart';
import 'package:roomtime/presentation/features/room/widgets/participant_tile.dart';
import 'package:roomtime/presentation/invite/invite_sharing.dart';
import 'package:roomtime/presentation/theme/theme.dart';

/// Review fixes inside the original dev-0.1.6 look (CR-1, F2, F4, CR-4,
/// F12).
void main() {
  Widget app(Widget child, {bool reduceMotion = false}) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: Scaffold(backgroundColor: Colors.black, body: child),
      ),
    ),
  );

  group('CR-1 speaking highlight', () {
    testWidgets('the glow is drawn behind the video, the border on top', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const SizedBox(
            width: 200,
            height: 150,
            child: ParticipantTile(
              participant: CallParticipant(
                id: 'PA_a',
                identity: 'p_a',
                displayName: 'Anna',
                isLocal: false,
                isSpeaking: true,
                microphoneEnabled: true,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ParticipantTile),
              matching: find.byType(Container),
            )
            .first,
      );
      final behind = container.decoration! as BoxDecoration;
      final front = container.foregroundDecoration! as BoxDecoration;
      expect(behind.boxShadow, isNotEmpty);
      expect(front.boxShadow, isNull);
      expect(front.border, isNotNull);
    });
  });

  group('F2 destructive confirmation', () {
    testWidgets('red #FF453A with black text; focus starts on Cancel', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showGlassConfirm(
                context: context,
                title: 'End for everyone?',
                confirmLabel: 'End',
                cancelLabel: 'Cancel',
                destructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final endFill = tester.widget<Container>(
        find
            .ancestor(of: find.text('End'), matching: find.byType(Container))
            .first,
      );
      expect((endFill.decoration! as BoxDecoration).color, AppColors.error);
      final endText = tester.widget<Text>(find.text('End'));
      expect(endText.style?.color, Colors.black);
      final cancelText = tester.widget<Text>(find.text('Cancel'));
      expect(cancelText.style?.color, Colors.white);

      final focused = FocusManager.instance.primaryFocus!.context!;
      expect(
        find.descendant(
          of: find.byWidget(focused.widget),
          matching: find.text('Cancel'),
        ),
        findsOneWidget,
      );
    });
  });

  group('F4 copy confirmation', () {
    testWidgets('shows above an open dialog and goes away', (tester) async {
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
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showGlassDialog<void>(
                context: context,
                builder: (context) => GlassDialogContent(
                  title: 'Invite',
                  actions: [
                    GlassDialogButton(
                      label: 'Copy link',
                      onPressed: () =>
                          copyWithConfirmation(context, 'link', 'Copied'),
                    ),
                  ],
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy link'));
      await tester.pump();

      expect(find.text('Copied'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      // In the root overlay, above the dialog route (not a route SnackBar).
      expect(
        find.descendant(
          of: find.byType(Overlay).first,
          matching: find.text('Copied'),
        ),
        findsOneWidget,
      );

      await tester.pump(copiedHudDuration);
      expect(find.text('Copied'), findsNothing);
      expect(find.text('Invite'), findsOneWidget);
    });
  });

  group('CR-4 HUD reduced motion', () {
    testWidgets('no slide and no duration with reduced motion', (tester) async {
      final controller = CallNoticeController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        app(CallNotice(controller: controller), reduceMotion: true),
      );
      controller.show('Anna joined');
      await tester.pump();

      final switcher = tester.widget<AnimatedSwitcher>(
        find.byType(AnimatedSwitcher),
      );
      expect(switcher.duration, Duration.zero);
      expect(
        find.descendant(
          of: find.byType(CallNotice),
          matching: find.byType(SlideTransition),
        ),
        findsNothing,
      );
      expect(find.text('Anna joined'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  group('F12 disabled media control', () {
    testWidgets('not focusable and offers no tap to screen readers', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        app(
          const Center(
            child: MediaControlButton(
              icon: Icons.cameraswitch,
              label: 'Flip camera',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Flip camera')),
        isSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      expect(
        find.descendant(
          of: find.byType(MediaControlButton),
          matching: find.byType(ExcludeFocus),
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });
}
