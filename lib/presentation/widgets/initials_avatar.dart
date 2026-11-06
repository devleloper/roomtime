import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;
  final String? colorSeed;
  final double size;
  final String? semanticLabel;

  const InitialsAvatar({
    super.key,
    required this.name,
    this.colorSeed,
    this.size = AppSizes.avatar,
    this.semanticLabel,
  });

  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2);
    final initials = words.map((word) => word.characters.first).join();
    if (initials.isEmpty) {
      return '?';
    }
    return initials.toUpperCase();
  }

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
    if (semanticLabel == null) {
      return ExcludeSemantics(child: avatar);
    }
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: avatar),
    );
  }
}

class AvatarTilePlaceholder extends StatelessWidget {
  final String name;
  final String? colorSeed;

  const AvatarTilePlaceholder({super.key, required this.name, this.colorSeed});

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
