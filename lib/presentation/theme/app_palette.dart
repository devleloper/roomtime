import 'package:flutter/painting.dart';

/// Raw brand palette. The only place in the app with color literals.
///
/// Widgets never read this class directly: they read [ColorScheme] roles or
/// `AppSemanticColors` from the theme. Contrast ratios for every pair used by
/// the theme are documented in `docs/design/tokens.md` and enforced by
/// `test/presentation/widgets/theme_contrast_test.dart`.
abstract final class AppPalette {
  // Brand (RoomTime identity, docs/design/identity.md). Blue tones share
  // OKLCH hue 240 with Brand Blue; the number is the approximate M3 tone.
  // Apricot tones (hue 58-68) are the complementary accent.

  /// RoomTime Blue, the project's main color: icon tiles, the mark on dark
  /// surfaces, dark-theme primary and focus ring.
  /// On #121212 7.58:1; on #333333 5.11:1. Too light for white text (2.47:1)
  /// and for marks on light surfaces (2.35:1): use [blue55] / [blue40] there.
  static const Color brandBlue = Color(0xFF00AEFF);

  /// The mark on light surfaces: on #F9F9FB 3.97:1, on #E1E2E4 3.22:1,
  /// on #121212 4.49:1.
  static const Color blue55 = Color(0xFF0083C3);

  /// Light-theme primary and focus ring, dark inversePrimary.
  /// White on it 5.91:1; on #F9F9FB 5.62:1.
  static const Color blue40 = Color(0xFF006A9E);
  static const Color blue30 = Color(0xFF004D74);
  static const Color blue90 = Color(0xFFCCE9FF);

  /// Ink (blue 10): wordmark on light, light onPrimaryContainer, dark
  /// onPrimary (6.98:1 on [brandBlue]).
  static const Color ink = Color(0xFF001D2F);

  /// Doorlight: complementary accent (OKLCH hue 64 vs 240), dark tertiary.
  /// Never inside a blue mark: on [brandBlue] only 1.38:1.
  static const Color doorlight = Color(0xFFFFB164);

  // Secondary: blue-tinted grey ("mist").
  static const Color mist10 = Color(0xFF05131D);
  static const Color mist20 = Color(0xFF1B2B36);
  static const Color mist30 = Color(0xFF31424E);
  static const Color mist40 = Color(0xFF4C5D6A);
  static const Color mist80 = Color(0xFFB7CAD9);
  static const Color mist90 = Color(0xFFD4E8F7);

  // Tertiary: apricot, the accent family of [doorlight].
  static const Color apricot10 = Color(0xFF361900);
  static const Color apricot20 = Color(0xFF582F02);
  static const Color apricot30 = Color(0xFF773F05);
  static const Color apricot40 = Color(0xFF9B540C);
  static const Color apricot90 = Color(0xFFFEDFBE);

  // Neutrals, dark theme (surface #121212 keeps the 18.73:1 text contrast).
  static const Color neutral0 = Color(0xFF000000);
  static const Color neutral7 = Color(0xFF121212);
  static const Color neutral12 = Color(0xFF1E1E1E);
  static const Color neutral16 = Color(0xFF282828);
  static const Color neutral20 = Color(0xFF333333);
  static const Color neutral22 = Color(0xFF383838);
  static const Color neutral27 = Color(0xFF444444);
  static const Color neutral54 = Color(0xFF8A8A8A);
  static const Color neutral67 = Color(0xFFAAAAAA);
  static const Color neutral90 = Color(0xFFE6E6E6);
  static const Color neutral100 = Color(0xFFFFFFFF);

  // Neutrals, light theme.
  static const Color slate10 = Color(0xFF1A1C1E);
  static const Color slate19 = Color(0xFF2F3033);
  static const Color slate29 = Color(0xFF42474E);
  static const Color slate47 = Color(0xFF72777F);
  static const Color slate79 = Color(0xFFC2C7CF);
  static const Color slate88 = Color(0xFFE1E2E4);
  static const Color slate90 = Color(0xFFE7E8EA);
  static const Color slate93 = Color(0xFFEDEEF0);
  static const Color slate95 = Color(0xFFF1F0F4);
  static const Color slate96 = Color(0xFFF3F4F6);
  static const Color slate98 = Color(0xFFF9F9FB);

  // Error (M3 baseline tones).
  static const Color red10 = Color(0xFF410002);
  static const Color red30 = Color(0xFF93000A);
  static const Color red40 = Color(0xFFBA1A1A);
  static const Color red90 = Color(0xFFFFDAD6);

  /// iOS systemRed, the dev-0.1.6 error color: error text, hang-up and
  /// device-off glass tints. On black 6.16:1, on #1E1E1E 4.90:1; white on
  /// it only 3.41:1 (icons yes, body text no).
  static const Color systemRed = Color(0xFFFF453A);

  /// iOS systemGreen (dev-0.1.6 `AppColors.success`).
  static const Color systemGreen = Color(0xFF34C759);

  /// Fill for destructive actions (leave, end for everyone); white on it 5.62:1.
  static const Color danger = Color(0xFFC62828);

  // Warning (reconnecting banner).
  static const Color amber10 = Color(0xFF261A00);
  static const Color amber25 = Color(0xFF4A3800);
  static const Color amber90 = Color(0xFFFFDF9E);

  /// Minimum backdrop for text over video (name tags, room pill, camera
  /// veil): black 60 %. White text on it stays >= 5.74:1 even over a pure
  /// white frame.
  static const Color videoScrim = Color(0x99000000);

  /// Soft white for glass over video (20 %); the glass rim itself is the
  /// specular stroke of `GlassEffect`.
  static const Color videoGlass = Color(0x33FFFFFF);

  /// Initials avatar backgrounds; white initials on each >= 6.06:1.
  static const List<Color> avatar = [
    Color(0xFF1E6091),
    Color(0xFF6A4C93),
    Color(0xFF2D6A4F),
    Color(0xFF9C4221),
    Color(0xFF8E3B5B),
    Color(0xFF4A5568),
    Color(0xFF00687A),
    Color(0xFF7C5E10),
  ];
}
