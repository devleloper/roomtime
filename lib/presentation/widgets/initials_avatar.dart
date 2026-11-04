import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_tokens.dart';

/// Circle with up to two initials on a color derived from [colorSeed]
/// (participant identity) or [name]. White initials on every palette color
/// are >= 6.06:1.
///
/// Decorative by default: the participant's name is shown and announced by
/// the tile. Pass [semanticLabel] when the avatar stands alone.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.name,
    this.colorSeed,
    this.size = AppSizes.avatar,
    this.semanticLabel,
  });

  final String name;
  final String? colorSeed;
  final double size;
  final String? semanticLabel;

  /// "Анна Петрова" -> "АП", "bob" -> "B", "" -> "?".
  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2);
    final initials = words.map((word) => word.characters.first).join();
    return initials.isEmpty ? '?' : initials.toUpperCase();
  }

  /// Stable across runs and platforms (unlike `String.hashCode` on web).
  static Color colorFor(String seed) {
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return AppPalette.avatar[hash % AppPalette.avatar.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatar = SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorFor(colorSeed ?? name),
        ),
        child: Center(
          child: Text(
            initialsOf(name),
            // The circle has a fixed size and the initials are decorative;
            // the readable name is rendered elsewhere at the user's text size.
            textScaler: TextScaler.noScaling,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: size * 0.4,
              color: AppPalette.neutral100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: avatar)
        : Semantics(
            label: semanticLabel,
            image: true,
            child: ExcludeSemantics(child: avatar),
          );
  }
}

/// Fills a video tile when the camera is off: avatar centered on a neutral
/// surface, scaled to the tile.
class AvatarTilePlaceholder extends StatelessWidget {
  const AvatarTilePlaceholder({super.key, required this.name, this.colorSeed});

  final String name;
  final String? colorSeed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shortest = constraints.biggest.shortestSide;
          final size = (shortest.isFinite ? shortest * 0.35 : AppSizes.iconXl)
              .clamp(AppSizes.avatarTileMin, AppSizes.avatarTileMax);
          return Center(
            child: InitialsAvatar(name: name, colorSeed: colorSeed, size: size),
          );
        },
      ),
    );
  }
}
