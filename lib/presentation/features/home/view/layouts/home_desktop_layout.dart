import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../widgets/widgets.dart';
import '../../widgets/home_actions.dart';
import '../../widgets/recent_rooms_list.dart';
import '../../../../shared/video_veil.dart';
import '../../../../theme/theme.dart';
import 'home_camera_toggle.dart';

/// Tablet and desktop Home of dev-0.1.6: a 380 px frosted sidebar on the
/// left (title, Create Room, join with a code, recent rooms with a 28 px
/// glass circle for the camera preview); the live camera stays sharp on the
/// right.
class HomeDesktopLayout extends StatelessWidget {
  const HomeDesktopLayout({super.key, required this.camera});

  final HomeCameraToggle? camera;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth > AppSizes.sidebarWidth
                  ? AppSizes.sidebarWidth
                  : constraints.maxWidth,
              child: VideoVeil(
                child: SafeArea(
                  right: false,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          context.l10n.appName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const CreateRoomButton(sidebar: true),
                      const SizedBox(height: 24),
                      HomeSectionLabel(context.l10n.homeJoinWithCode),
                      const SizedBox(height: 8),
                      const JoinWithCodeField(),
                      const SizedBox(height: 24),
                      HomeSectionLabel(
                        context.l10n.homeRecent,
                        trailing: switch (camera) {
                          // The 48 dp tap target pads the 28 dp circle by
                          // 10: shift it so the circle is flush with the
                          // CTA edge, as in 0.1.6 (F11).
                          final camera? => Transform.translate(
                            offset: Offset(
                              Directionality.of(context) == TextDirection.rtl
                                  ? -10
                                  : 10,
                              0,
                            ),
                            child: LiquidBounceButton(
                              onPressed: camera.onPressed,
                              icon: camera.on
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              bgColor: Colors.white.withValues(
                                alpha: AppGlass.secondaryFillAlpha,
                              ),
                              size: 28,
                              iconSize: 14,
                              semanticLabel: context.l10n.homeCameraPreview,
                              toggled: camera.on,
                            ),
                          ),
                          null => null,
                        },
                      ),
                      RecentRoomsList(
                        dividerColor: Colors.white.withValues(alpha: 0.1),
                        emptyFontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Empty space for the sharp camera view.
            const Expanded(child: SizedBox.expand()),
          ],
        );
      },
    );
  }
}
