import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/widgets.dart';

import 'harness.dart';

/// The dev-0.1.6 widgets with their original API and look, plus the
/// accessibility they carry without a visual change.
void main() {
  group('LiquidBounceButton', () {
    Widget mic({
      VoidCallback? onPressed,
      IconData icon = Icons.mic_off,
      double size = 60,
      double iconSize = 28,
      String? semanticLabel,
      bool? toggled,
    }) => LiquidBounceButton(
      onPressed: onPressed ?? () {},
      icon: icon,
      bgColor: AppColors.error.withValues(alpha: 0.4),
      size: size,
      iconSize: iconSize,
      semanticLabel: semanticLabel,
      toggled: toggled,
    );

    testWidgets('0.1.6 look: glass circle, tint, blur 24, white icon', (
      tester,
    ) async {
      await pumpApp(tester, mic());
      final glass = tester.widget<GlassEffect>(find.byType(GlassEffect));
      expect(glass.oval, isTrue);
      expect(glass.blurSigma, AppGlass.blurSigma);
      expect(glass.tint, AppColors.error.withValues(alpha: 0.4));
      expect(tester.getSize(find.byType(GlassEffect)), const Size.square(60));
      final icon = tester.widget<Icon>(find.byIcon(Icons.mic_off));
      expect(icon.color, AppColors.textPrimary);
      expect(icon.size, 28);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('named toggle from the 0.1.6 icon; label wins when given', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester, mic());
      expect(
        tester.getSemantics(find.bySemanticsLabel('Microphone')),
        isSemantics(
          label: 'Microphone',
          isButton: true,
          isFocusable: true,
          hasEnabledState: true,
          isEnabled: true,
          hasToggledState: true,
          isToggled: false,
          hasTapAction: true,
        ),
      );
      expect(find.byTooltip('Microphone'), findsOneWidget);

      await pumpApp(
        tester,
        mic(semanticLabel: 'Микрофон', toggled: true, icon: Icons.mic),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Микрофон')),
        isSemantics(hasToggledState: true, isToggled: true, isButton: true),
      );
      handle.dispose();
    });

    testWidgets('keyboard: focus ring, Enter and Space activate', (
      tester,
    ) async {
      var taps = 0;
      await pumpApp(tester, mic(onPressed: () => taps++));
      FocusRing ring() => tester.widget<FocusRing>(find.byType(FocusRing));
      expect(ring().visible, isFalse);
      await tab(tester);
      expect(ring().visible, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('press: 1.15 bounce and white glare, back on release', (
      tester,
    ) async {
      var taps = 0;
      await pumpApp(tester, mic(onPressed: () => taps++));
      double scale() =>
          tester.widget<AnimatedScale>(find.byType(AnimatedScale).first).scale;
      double glare() => tester
          .widget<AnimatedOpacity>(
            find.descendant(
              of: find.byType(GlassEffect),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(LiquidBounceButton)),
      );
      await tester.pump();
      expect(scale(), AppMotion.bounceScale);
      expect(glare(), AppGlass.pressedGlareAlpha);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(scale(), 1);
      expect(glare(), 0);
      expect(taps, 1);
    });

    testWidgets('drag stretches the glass, release springs back', (
      tester,
    ) async {
      await pumpApp(tester, mic());
      Matrix4 stretch() => tester
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(LiquidBounceButton),
                  matching: find.byType(Transform),
                )
                .last,
          )
          .transform;
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(LiquidBounceButton)),
      );
      await gesture.moveBy(const Offset(30, 0));
      await tester.pump();
      expect(stretch().isIdentity(), isFalse);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(stretch().isIdentity(), isTrue);
    });

    testWidgets('28 dp sidebar circle keeps its size and a 48 dp target', (
      tester,
    ) async {
      var taps = 0;
      await pumpApp(
        tester,
        mic(
          onPressed: () => taps++,
          icon: Icons.refresh,
          size: 28,
          iconSize: 14,
        ),
      );
      expect(tester.getSize(find.byType(GlassEffect)), const Size.square(28));
      final target = tester.getSize(find.byType(LiquidBounceButton));
      expect(target.width, greaterThanOrEqualTo(AppSizes.minTarget));
      expect(target.height, greaterThanOrEqualTo(AppSizes.minTarget));
      // A tap just outside the visible circle still hits.
      final circle = tester.getRect(find.byType(GlassEffect));
      await tester.tapAt(circle.topLeft - const Offset(4, 4));
      expect(taps, 1);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    });

    testWidgets('reduced motion: no bounce, stretch or crossfade', (
      tester,
    ) async {
      await pumpApp(tester, mic(), disableAnimations: true);
      expect(find.byType(AnimatedScale), findsNothing);
      expect(find.byType(AnimatedSwitcher), findsNothing);
      expect(
        find.descendant(
          of: find.byType(LiquidBounceButton),
          matching: find.byType(Transform),
        ),
        findsNothing,
      );
    });
  });

  group('CustomBounceButton', () {
    Widget cta({VoidCallback? onPressed, double scaleFactor = 1.08}) =>
        CustomBounceButton(
          onPressed: onPressed ?? () {},
          scaleFactor: scaleFactor,
          borderRadius: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.video_call), Text('Create Room')],
            ),
          ),
        );

    testWidgets('one button named by its text, Enter activates', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpApp(tester, cta(onPressed: () => taps++));
      expect(
        tester.getSemantics(find.bySemanticsLabel('Create Room')),
        isSemantics(
          label: 'Create Room',
          isButton: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );
      await tab(tester);
      expect(tester.widget<FocusRing>(find.byType(FocusRing)).visible, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('icon-only child takes semanticLabel', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(
        tester,
        CustomBounceButton(
          onPressed: () {},
          semanticLabel: 'Settings',
          child: const Icon(Icons.settings, size: 24),
        ),
      );
      expect(find.bySemanticsLabel('Settings'), findsOneWidget);
      final size = tester.getSize(find.byType(CustomBounceButton));
      expect(size.width, greaterThanOrEqualTo(AppSizes.minTarget));
      expect(size.height, greaterThanOrEqualTo(AppSizes.minTarget));
      expect(tester.getSize(find.byIcon(Icons.settings)).width, 24);
      handle.dispose();
    });

    testWidgets('press: scaleFactor bounce, 20 % white glare', (tester) async {
      await pumpApp(tester, cta(scaleFactor: 1.2));
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(CustomBounceButton)),
      );
      await tester.pump();
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        1.2,
      );
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        AppGlass.pressedGlareAlpha,
      );
      await gesture.up();
      await tester.pumpAndSettle();
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
    });

    testWidgets('reduced motion: no scale', (tester) async {
      await pumpApp(tester, cta(), disableAnimations: true);
      expect(find.byType(AnimatedScale), findsNothing);
    });
  });

  group('LiquidGlassContainer', () {
    testWidgets('defaults: blur 12 x 2, surface 40 %, rim, radius 16', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const LiquidGlassContainer(child: SizedBox.square(dimension: 80)),
      );
      final glass = tester.widget<GlassEffect>(find.byType(GlassEffect));
      expect(glass.blurSigma, 24);
      expect(
        glass.tint,
        AppTheme.dark.colorScheme.surface.withValues(alpha: 0.4),
      );
      expect(glass.borderRadius, BorderRadius.circular(16));
      expect(glass.rimColor.a, greaterThan(0));
    });

    testWidgets('home veil: blur 30, black 50 %, no rim', (tester) async {
      await pumpApp(
        tester,
        LiquidGlassContainer(
          blur: 30,
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          borderColor: Colors.transparent,
          borderRadius: 0,
          child: const SizedBox.square(dimension: 80),
        ),
      );
      final glass = tester.widget<GlassEffect>(find.byType(GlassEffect));
      expect(glass.blurSigma, 60);
      expect(glass.rimColor.a, 0);
    });

    testWidgets('renders the same on every platform', (tester) async {
      for (final platform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = platform;
        await pumpApp(
          tester,
          const LiquidGlassContainer(child: SizedBox.square(dimension: 40)),
        );
        expect(
          find.byType(BackdropFilter),
          findsOneWidget,
          reason: '$platform',
        );
      }
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('CustomCard: surface, radius 24, padding 20, shadow', (
    tester,
  ) async {
    await pumpApp(tester, const CustomCard(child: Text('Card')));
    final box = tester.widget<Container>(find.byType(Container));
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(24));
    expect(decoration.boxShadow, isNotEmpty);
    expect(box.padding, const EdgeInsets.all(20));
  });

  group('text fields (QA D2, D4)', () {
    EditableText editable(WidgetTester tester) =>
        tester.widget<EditableText>(find.byType(EditableText));

    void expectUnaltered(EditableText field) {
      expect(field.autocorrect, isFalse);
      expect(field.enableSuggestions, isFalse);
      expect(field.textCapitalization, TextCapitalization.none);
      expect(field.smartDashesType, SmartDashesType.disabled);
      expect(field.smartQuotesType, SmartQuotesType.disabled);
    }

    testWidgets('CustomTextField password: obscured, typed text unaltered', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpApp(
        tester,
        CustomTextField(
          controller: controller,
          hintText: 'Password',
          isPassword: true,
        ),
      );
      expect(editable(tester).obscureText, isTrue);
      expectUnaltered(editable(tester));
      // 0.1.6 look: surface fill, radius 16.
      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!;
      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, AppColors.surface);
      expect(
        (decoration.enabledBorder! as OutlineInputBorder).borderRadius,
        BorderRadius.circular(16),
      );
      // The hint names the field for screen readers.
      final handle = tester.ensureSemantics();
      await tester.pump();
      expect(
        tester.getSemantics(find.bySemanticsLabel('Password')),
        isSemantics(isTextField: true, isObscured: true),
      );
      handle.dispose();
    });

    testWidgets('CustomTextField text: platform defaults kept', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpApp(
        tester,
        CustomTextField(controller: controller, hintText: 'Name'),
      );
      expect(editable(tester).obscureText, isFalse);
      expect(editable(tester).autocorrect, isTrue);
      expect(editable(tester).autofocus, isFalse);
      expect(editable(tester).textInputAction, isNull);
    });

    testWidgets('CustomTextField focus: 0.1.6 look, 2 dp blue for keyboard', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      await pumpApp(
        tester,
        CustomTextField(controller: controller, hintText: 'Room code'),
      );
      OutlineInputBorder? border() {
        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        final d = decorator.decoration;
        return (decorator.isFocused ? d.focusedBorder : d.enabledBorder)
            as OutlineInputBorder?;
      }

      final rest = border()!;
      expect(rest.borderSide.color, AppColors.surface);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(border()!.borderSide.color, AppColors.surface);

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      await tester.pump();
      final focused = border()!;
      expect(focused.borderSide.color, AppColors.primary);
      expect(focused.borderSide.width, AppSizes.fieldBorderWidth);
      expect(focused.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('CustomTextField: Enter submits, formatters, focus node', (
      tester,
    ) async {
      final controller = TextEditingController();
      final node = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(node.dispose);
      String? submitted;
      await pumpApp(
        tester,
        CustomTextField(
          controller: controller,
          hintText: 'Room code',
          focusNode: node,
          autofocus: true,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) => submitted = value,
          inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        ),
      );
      await tester.pump();
      expect(node.hasFocus, isTrue);
      expect(editable(tester).textInputAction, TextInputAction.go);
      await tester.enterText(find.byType(TextField), 'ab cd');
      expect(controller.text, 'abcd');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      expect(submitted, 'abcd');
    });
  });
}
