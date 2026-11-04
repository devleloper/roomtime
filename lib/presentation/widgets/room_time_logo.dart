import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// The RoomTime logo: the "Door swing" mark (option C: an open door leaf and
/// its quarter swing, also a clock hand's quarter turn), optionally with the
/// wordmark. Vector (no bitmap asset), same geometry as
/// `assets/brand/src/marks/roomtime-mark-c.svg`; usage rules in
/// `docs/design/identity.md`.
///
/// - Default: one-color mark whose blue follows the theme: RoomTime Blue on
///   dark surfaces (7.58:1 on #121212, 5.11:1 on #333333), Blue 55 on light
///   surfaces (3.97:1 on #F9F9FB).
/// - [reversed]: white mark, for brand-blue backgrounds and photos or video
///   under a scrim.
///
/// The logo is an image: it ignores the text scale (its size is set by
/// [size]) and announces [semanticLabel] once. Pass `semanticLabel: null`
/// when the name is already rendered or read next to it.
class RoomTimeLogo extends StatelessWidget {
  const RoomTimeLogo({
    super.key,
    this.size = 48,
    this.showWordmark = false,
    this.reversed = false,
    this.semanticLabel = brandName,
  });

  /// Product name; a proper noun, not translated.
  static const String brandName = 'RoomTime';

  /// Height of the mark artboard; the glyph is 70 x 52 units of 96.
  final double size;
  final bool showWordmark;
  final bool reversed;
  final String? semanticLabel;

  // Lockup proportions on the 96-unit grid (identity.md, "Construction").
  static const double _grid = 96;
  static const double _capHeight = 30;
  static const double _gap = 16;
  static const double _artboardMargin = 13; // right edge of the glyph: 83
  static const double _interCapHeight = 0.7275; // Inter cap height, em
  static const double _tracking = -0.02; // em

  @override
  Widget build(BuildContext context) {
    final unit = size / _grid;
    final dark = reversed || Theme.of(context).brightness == Brightness.dark;
    Widget logo = CustomPaint(
      size: Size.square(size),
      painter: _MarkPainter(
        color: reversed
            ? AppPalette.neutral100
            : dark
            ? AppPalette.brandBlue
            : AppPalette.blue55,
      ),
    );
    if (showWordmark) {
      final fontSize = _capHeight * unit / _interCapHeight;
      // An image scales down as a whole instead of overflowing.
      logo = FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo,
            SizedBox(width: (_gap - _artboardMargin) * unit),
            Text(
              brandName,
              maxLines: 1,
              softWrap: false,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                // Brand artwork: Inter on every platform (the asset SVGs).
                fontFamily: AppTypography.webFontFamily,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                letterSpacing: _tracking * fontSize,
                color: dark ? AppPalette.neutral100 : AppPalette.ink,
                // Artwork: no inherited decoration (e.g. outside Material).
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    }
    final label = semanticLabel;
    return label == null
        ? ExcludeSemantics(child: logo)
        : Semantics(
            label: label,
            image: true,
            child: ExcludeSemantics(child: logo),
          );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.color});

  final Color color;

  /// `roomtime-mark-c.svg#mark`: the door leaf, then the quarter swing
  /// (hinge (31, 74), radius 52).
  static final Path _mark = Path()
    ..moveTo(13, 28)
    ..arcToPoint(const Offset(25, 28), radius: const Radius.circular(6))
    ..lineTo(25, 74)
    ..lineTo(13, 74)
    ..close()
    ..moveTo(31, 74)
    ..lineTo(31, 22)
    ..arcToPoint(const Offset(83, 74), radius: const Radius.circular(52))
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / RoomTimeLogo._grid);
    canvas.drawPath(_mark, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}
