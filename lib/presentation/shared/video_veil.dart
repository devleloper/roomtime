import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/widgets.dart';

/// The dev-0.1.6 frosted veil over the live camera (Home on phones, the
/// Home sidebar): blur 30 and black, edge to edge. The tint is
/// `black @ 0.6` (0.1.6 had 0.5) so the secondary text on it keeps 4.5:1
/// over a bright frame.
class VideoVeil extends StatelessWidget {
  const VideoVeil({super.key, this.child = const SizedBox.expand()});

  /// Black alpha of the veil.
  static const double tintAlpha = 0.6;

  final Widget child;

  @override
  Widget build(BuildContext context) => LiquidGlassContainer(
    blur: AppGlass.veilBlurSigma / AppGlass.blurFactor,
    backgroundColor: Colors.black.withValues(alpha: tintAlpha),
    borderColor: Colors.transparent,
    borderRadius: 0,
    child: child,
  );
}
