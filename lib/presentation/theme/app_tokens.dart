import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

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

abstract final class AppElevation {
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;
}

abstract final class AppSizes {
  static const double minTarget = 48;

  static const double iconSm = 20;
  static const double icon = 24;
  static const double iconLg = 28;
  static const double iconXl = 48;

  static const double avatar = 40;
  static const double avatarTileMin = 32;
  static const double avatarTileMax = 120;

  static const double fieldBorderWidth = 2;

  static const double focusRingWidth = 3;
  static const double focusRingGap = 2;

  static const double dialogMaxWidth = 560;

  static const double glassDialogMaxWidth = 420;

  static const double glassControl = 60;

  static const double glassPillHeight = 44;

  static const Size dynamicIsland = Size(125, 37);
  static const double dynamicIslandTop = 11;

  static const double sidebarWidth = 380;

  static const Size pip = Size(120, 160);
}

abstract final class AppGlass {
  static const double blurFactor = 2;

  static const double containerBlur = 12;

  static const double blurSigma = 24;

  static const double veilBlurSigma = 60;

  static const double saturation = 1.5;
  static const double lightAngle = math.pi / 2;
  static const double lightIntensity = 0.5;
  static const double thickness = 20;

  static const double containerTintAlpha = 0.4;
  static const double dialogTintAlpha = 0.5;

  static const double borderAlpha = 0.15;
  static const double dialogBorderAlpha = 0.2;
  static const double subtleBorderAlpha = 0.1;

  static const double fieldBorderAlpha = 0.2;

  static const double panelMinAlpha = 0.72;

  static const double fallbackMinAlpha = 0.94;

  static const double overlayMinAlpha = 0.6;
  static const double overlayFallbackMinAlpha = 0.8;

  static const double pressedGlareAlpha = 0.2;

  static const double secondaryFillAlpha = 0.1;

  static const double labelAlpha = 0.7;
}

abstract final class AppMotion {
  static const Duration fast = Durations.short2;
  static const Duration short = Durations.short4;
  static const Duration medium = Durations.medium2;
  static const Duration long = Durations.long2;

  static const Curve standard = Easing.standard;
  static const Curve enter = Easing.emphasizedDecelerate;
  static const Curve exit = Easing.emphasizedAccelerate;

  static const double pressedScale = 0.94;

  static const double bounceScale = 1.15;
  static const double bounceScaleSmall = 1.08;
  static const Duration pressIn = Duration(milliseconds: 150);
  static const Duration pressRelease = medium;
  static const Curve pressInCurve = Curves.easeOut;
  static const Curve pressReleaseCurve = Curves.easeOutBack;

  static const Duration glare = pressIn;
  static const Curve glareCurve = Curves.easeInOut;

  static const double stretchScale = 1.05;
  static const double stretchFactor = 0.2;
  static const double stretchResistance = 0.08;
  static const Duration stretchIn = medium;
  static const Duration stretchSettle = long;
  static const Curve stretchSettleCurve = Curves.easeOutBack;

  static const Duration islandMorph = Duration(milliseconds: 650);
  static const Curve islandMorphCurve = Curves.easeOutQuint;

  static const Duration pillIn = Duration(milliseconds: 400);
  static const Duration pillOut = medium;
  static const Curve chromeCurve = Curves.easeOutCubic;

  static const Duration chromeAutoHide = Duration(seconds: 4);

  static const Duration pipSnap = medium;

  static const Duration gridReflow = Duration(milliseconds: 650);
  static const Curve gridReflowCurve = Curves.elasticOut;

  static bool reduced(BuildContext context) {
    return MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  static Duration resolve(BuildContext context, Duration duration) {
    if (reduced(context)) {
      return Duration.zero;
    }
    return duration;
  }
}

enum WindowSizeClass {
  compact(0),

  medium(600),

  expanded(840),

  large(1200),

  extraLarge(1600);

  final double minWidth;

  const WindowSizeClass(this.minWidth);

  bool get isCompact => this == compact;

  static WindowSizeClass fromWidth(double width) {
    for (final sizeClass in values.reversed) {
      if (width >= sizeClass.minWidth) {
        return sizeClass;
      }
    }
    return compact;
  }

  static WindowSizeClass of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }

  bool isAtLeast(WindowSizeClass other) => index >= other.index;
}
