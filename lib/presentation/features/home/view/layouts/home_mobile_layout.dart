import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/widgets.dart';
import '../../widgets/home_actions.dart';
import '../../widgets/recent_rooms_list.dart';
import '../../../../shared/platform.dart';
import '../../../../shared/video_veil.dart';
import 'home_camera_toggle.dart';

/// Phone Home of dev-0.1.6: a full-screen frosted veil over the camera,
/// the title with a 48 px glass circle (camera preview) at the top, the
/// Create Room CTA, then join with a code and the recent rooms where 0.1.6
/// listed the public rooms.
class HomeMobileLayout extends StatelessWidget {
  const HomeMobileLayout({super.key, required this.camera});

  final HomeCameraToggle? camera;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Subtle background blur for text legibility over the camera feed.
        const Positioned.fill(child: VideoVeil()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isMacOSApp ? 48 : 16),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          context.l10n.appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    if (camera case final camera?)
                      LiquidBounceButton(
                        onPressed: camera.onPressed,
                        icon: camera.on ? Icons.videocam : Icons.videocam_off,
                        bgColor: AppColors.surface.withValues(alpha: 0.4),
                        size: 48,
                        iconSize: 24,
                        semanticLabel: context.l10n.homeCameraPreview,
                        toggled: camera.on,
                      ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 24, bottom: 24),
                    children: [
                      const CreateRoomButton(),
                      const SizedBox(height: 32),
                      HomeSectionLabel(context.l10n.homeJoinWithCode),
                      const SizedBox(height: 8),
                      const JoinWithCodeField(),
                      const SizedBox(height: 32),
                      HomeSectionLabel(context.l10n.homeRecent),
                      const RecentRoomsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
