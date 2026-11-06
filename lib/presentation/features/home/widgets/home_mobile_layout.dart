import 'package:flutter/material.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/home/widgets/home_actions.dart';
import 'package:roomtime/presentation/features/home/widgets/join_with_code_field.dart';
import 'package:roomtime/presentation/features/home/widgets/recent_rooms_list.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/liquid_bounce_button.dart';

class HomeMobileLayout extends StatelessWidget {
  final HomeCameraToggle? camera;

  const HomeMobileLayout({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
