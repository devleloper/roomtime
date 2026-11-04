import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Spacing scale on a 4 dp grid. Use these instead of literal paddings.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Inner padding of `CustomCard` (dev-0.1.6).
  static const double card = 20;
}

/// Corner radii (M3 shape scale).
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 28;
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}

/// M3 elevation levels in dp.
abstract final class AppElevation {
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;
}

/// Shadows. Glass has none (0.1.6); only `CustomCard` casts one.
abstract final class AppShadows {
  /// `CustomCard`: black 20 %, blur 20, 10 down.
  static final List<BoxShadow> card = [
    BoxShadow(
      color: AppPalette.neutral0.withValues(alpha: 0.2),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}

/// Component sizes.
abstract final class AppSizes {
  /// Minimum interactive target on every platform (Material 48 dp, covers
  /// the iOS 44 pt guideline).
  static const double minTarget = 48;

  static const double iconSm = 20;
  static const double icon = 24;
  static const double iconLg = 28;
  static const double iconXl = 48;

  /// Initials avatar: default, and the bounds inside a video tile.
  static const double avatar = 40;
  static const double avatarTileMin = 32;
  static const double avatarTileMax = 120;

  /// `CustomTextField` border (0.1.6: 2 dp in the fill color). The rim is a
  /// hairline; the focused border uses the full width.
  static const double fieldBorderWidth = 2;

  /// Keyboard focus ring: stroke width and gap to the control edge.
  static const double focusRingWidth = 3;
  static const double focusRingGap = 2;

  /// Max width of Material dialogs on wide windows.
  static const double dialogMaxWidth = 560;

  /// Glass dialog panel max width (0.1.6 stretched it on iPad; fixed).
  static const double glassDialogMaxWidth = 420;

  /// FaceTime-style chrome (reference: dev-0.1.6, docs/design/flows.md §14).
  /// Round glass call control.
  static const double glassControl = 60;

  /// Small glass icon circle (refresh in a header); the hit target stays
  /// [minTarget].
  static const double glassControlSmall = 28;

  /// Room-name glass pill: minimum height.
  static const double glassPillHeight = 44;

  /// Hardware Dynamic Island the room pill morphs out of (portrait).
  static const Size dynamicIsland = Size(125, 37);
  static const double dynamicIslandTop = 11;

  /// Veiled sidebar on tablets and desktop; the camera stays sharp beside it.
  static const double sidebarWidth = 380;

  /// Local preview picture-in-picture.
  static const Size pip = Size(120, 160);
}

/// Glass parameters: the dev-0.1.6 look on iOS/macOS, where
/// `liquid_glass_renderer` 0.2.0-dev.4 `FakeGlass` drew it (blur and
/// saturation of the backdrop, a multiplied tint, a specular rim lit from
/// above and below). `GlassEffect` reproduces that model with
/// `BackdropFilter` and canvas strokes only, so it is identical on iOS,
/// Android, macOS and web (the package's shaders broke `flutter build web`).
abstract final class AppGlass {
  /// 0.1.6 doubled the blur it passed to FakeGlass ("FakeGlass blur reads
  /// weaker"): a `LiquidGlassContainer(blur: 12)` is sigma 24.
  static const double blurFactor = 2;

  /// `LiquidGlassContainer` default blur (before [blurFactor]).
  static const double containerBlur = 12;

  /// Blur sigma of glass pills, panels and controls (12 x 2; the 0.1.6
  /// `LiquidBounceButton` passed 24 directly).
  static const double blurSigma = 24;

  /// Blur sigma of the full-screen camera veil and dialogs (30 x 2).
  static const double veilBlurSigma = 60;

  /// FakeGlass defaults (0.2.0-dev.4) that shape the look.
  static const double saturation = 1.5;
  static const double lightAngle = math.pi / 2;
  static const double lightIntensity = 0.5;
  static const double thickness = 20;

  /// 0.1.6 tints over `AppColors.surface` / black.
  static const double containerTintAlpha = 0.4;
  static const double dialogTintAlpha = 0.5;
  static const double veilTintAlpha = 0.5;

  /// Hairline rims of 0.1.6 (default, dialog, HUD). On iOS/macOS FakeGlass
  /// drew its specular rim instead; `GlassEffect` does the same everywhere.
  static const double borderAlpha = 0.15;
  static const double dialogBorderAlpha = 0.2;
  static const double subtleBorderAlpha = 0.1;

  /// Resting rim of outlined text fields: the 0.1.6 white 20 % hairline.
  /// 1.66:1 on black, below WCAG 1.4.11 (3:1): known contrast debt of the
  /// original look, kept until the user decides (white 45 % would give
  /// 4.41:1). Focus is the #00AEFF border.
  static const double fieldBorderAlpha = 0.2;

  /// Minimum tint alpha with blur over static backgrounds (GlassSurface).
  static const double panelMinAlpha = 0.72;

  /// Minimum tint alpha without blur (high contrast): near-opaque.
  static const double fallbackMinAlpha = 0.94;

  /// Minimum black alpha over video with blur (white text >= 5.74:1 on a
  /// pure white frame) and without blur.
  static const double overlayMinAlpha = 0.6;
  static const double overlayFallbackMinAlpha = 0.8;

  /// White glare while a glass control is pressed (0.1.6).
  static const double pressedGlareAlpha = 0.2;

  /// Fill of secondary buttons (0.1.6 dialog "Cancel": white 10 %).
  static const double secondaryFillAlpha = 0.1;

  /// Field labels (0.1.6: white 70 %).
  static const double labelAlpha = 0.7;
}

/// Motion tokens. Always resolve durations through [AppMotion.resolve] (or
/// check [AppMotion.reduced]) so that "Reduce motion" / "Remove animations"
/// makes non-essential animation instant.
abstract final class AppMotion {
  static const Duration fast = Durations.short2; // 100 ms
  static const Duration short = Durations.short4; // 200 ms
  static const Duration medium = Durations.medium2; // 300 ms
  static const Duration long = Durations.long2; // 500 ms

  static const Curve standard = Easing.standard;
  static const Curve enter = Easing.emphasizedDecelerate;
  static const Curve exit = Easing.emphasizedAccelerate;

  /// Press feedback scale for custom pressables.
  static const double pressedScale = 0.94;

  /// 0.1.6 bounce: glass controls grow to 1.15, other pressables to 1.08.
  /// In over [pressIn] with [Curves.easeOut], back over [pressRelease] with
  /// [Curves.easeOutBack].
  static const double bounceScale = 1.15;
  static const double bounceScaleSmall = 1.08;
  static const Duration pressIn = Duration(milliseconds: 150);
  static const Duration pressRelease = medium;
  static const Curve pressInCurve = Curves.easeOut;
  static const Curve pressReleaseCurve = Curves.easeOutBack;

  /// Glare fade of the 0.1.6 bounce buttons.
  static const Duration glare = pressIn;
  static const Curve glareCurve = Curves.easeInOut;

  /// `LiquidStretch` of 0.1.6 glass buttons: grow to 1.05 while touched and
  /// stretch toward a drag (0.2 of the resisted drag distance), springing
  /// back on release.
  static const double stretchScale = 1.05;
  static const double stretchFactor = 0.2;
  static const double stretchResistance = 0.08;
  static const Duration stretchIn = medium;
  static const Duration stretchSettle = long;
  static const Curve stretchSettleCurve = Curves.easeOutBack;

  /// Room pill morphing out of / into the Dynamic Island.
  static const Duration islandMorph = Duration(milliseconds: 650);
  static const Curve islandMorphCurve = Curves.easeOutQuint;

  /// Room pill fallback (no island): slide + fade.
  static const Duration pillIn = Duration(milliseconds: 400);
  static const Duration pillOut = medium;
  static const Curve chromeCurve = Curves.easeOutCubic;

  /// Call chrome (controls, pill) auto-hide delay and hide animation.
  static const Duration chromeAutoHide = Duration(seconds: 4);
  static const Duration chromeHide = medium;

  /// PiP snap to an edge; PiP/main swap (fade + scale 0.95 -> 1).
  static const Duration pipSnap = medium;
  static const Duration pipSwap = Duration(milliseconds: 400);

  /// Grid reflow when participants join or leave (springy).
  static const Duration gridReflow = Duration(milliseconds: 650);
  static const Curve gridReflowCurve = Curves.elasticOut;

  /// Camera switch: 3D flip of the local preview.
  static const Duration cameraFlip = Duration(milliseconds: 600);

  /// Home camera background: start delay after the route transition and the
  /// placeholder-to-live crossfade.
  static const Duration cameraStartDelay = Duration(milliseconds: 350);
  static const Duration cameraFadeIn = long;

  /// True when the platform asks to reduce or remove animations.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration], or [Duration.zero] when motion is reduced.
  static Duration resolve(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

/// M3 window size classes by width. Layout decisions only; input-dependent
/// behaviour (hover, shortcuts, focus model) must not be inferred from width.
enum WindowSizeClass {
  /// < 600: phones in portrait.
  compact(0),

  /// 600-839: tablets in portrait, foldables, narrow desktop windows.
  medium(600),

  /// 840-1199: tablets in landscape, desktop.
  expanded(840),

  /// 1200-1599.
  large(1200),

  /// >= 1600.
  extraLarge(1600);

  const WindowSizeClass(this.minWidth);

  final double minWidth;

  static WindowSizeClass fromWidth(double width) {
    for (final sizeClass in values.reversed) {
      if (width >= sizeClass.minWidth) {
        return sizeClass;
      }
    }
    return compact;
  }

  static WindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool isAtLeast(WindowSizeClass other) => index >= other.index;

  bool get isCompact => this == compact;
}
