import 'package:flutter/painting.dart';

abstract final class AppPalette {
  static const Color brandBlue = Color(0xFF00AEFF);
  static const Color blue40 = Color(0xFF006A9E);
  static const Color blue30 = Color(0xFF004D74);
  static const Color blue90 = Color(0xFFCCE9FF);

  static const Color doorlight = Color(0xFFFFB164);

  static const Color mist20 = Color(0xFF1B2B36);
  static const Color mist30 = Color(0xFF31424E);
  static const Color mist80 = Color(0xFFB7CAD9);
  static const Color mist90 = Color(0xFFD4E8F7);

  static const Color apricot20 = Color(0xFF582F02);
  static const Color apricot30 = Color(0xFF773F05);
  static const Color apricot90 = Color(0xFFFEDFBE);

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

  static const Color red30 = Color(0xFF93000A);
  static const Color red90 = Color(0xFFFFDAD6);
  static const Color systemRed = Color(0xFFFF453A);
  static const Color systemGreen = Color(0xFF34C759);

  static const Color danger = Color(0xFFC62828);

  static const Color amber25 = Color(0xFF4A3800);
  static const Color amber90 = Color(0xFFFFDF9E);

  static const Color videoScrim = Color(0x99000000);
  static const Color videoGlass = Color(0x33FFFFFF);

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

abstract final class AppColors {
  static const Color primary = AppPalette.brandBlue;
  static const Color background = AppPalette.neutral7;
  static const Color surface = AppPalette.neutral12;
  static const Color textPrimary = AppPalette.neutral100;
  static const Color textSecondary = AppPalette.neutral67;
  static const Color error = AppPalette.systemRed;
  static const Color success = AppPalette.systemGreen;
}
