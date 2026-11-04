import 'package:flutter/painting.dart';

import 'app_palette.dart';

/// The dev-0.1.6 color API (`AppColors`), kept for the original
/// FaceTime-style screens. Values come from [AppPalette]; the Material roles
/// built from them are in `AppColorSchemes.dark`.
///
/// Dark only: white text on black or on dark glass.
abstract final class AppColors {
  /// RoomTime Blue: Create Room CTA, dialog primary button, focused field
  /// border, room spinner. White labels on it are 2.47:1 (0.1.6 look,
  /// docs/design/tokens.md "Known contrast debt").
  static const Color primary = AppPalette.brandBlue;

  /// Default scaffold of 0.1.6 (#121212); Home and Room draw pure black.
  static const Color background = AppPalette.neutral7;

  /// Glass tint base (at 0.4-0.5 alpha) and the no-video tile fill.
  static const Color surface = AppPalette.neutral12;

  /// Titles and body text: 16.67:1 on [surface], 21:1 on black.
  static const Color textPrimary = AppPalette.neutral100;

  /// Hints: 7.18:1 on [surface], 9.04:1 on black.
  static const Color textSecondary = AppPalette.neutral67;

  /// iOS systemRed: error text, mic-off icon, hang-up tint.
  static const Color error = AppPalette.systemRed;
  static const Color success = AppPalette.systemGreen;
}
