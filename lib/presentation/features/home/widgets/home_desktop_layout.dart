import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/home/widgets/home_actions.dart';
import 'package:roomtime/presentation/features/home/widgets/join_with_code_field.dart';
import 'package:roomtime/presentation/features/home/widgets/recent_rooms_list.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/liquid_bounce_button.dart';

class HomeDesktopLayout extends StatelessWidget {
  final HomeCameraToggle? camera;

  const HomeDesktopLayout({super.key, required this.camera});

  Widget? _buildCameraToggle(BuildContext context) {
    final toggle = camera;
    if (toggle == null) {
      return null;
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Transform.translate(
      offset: Offset(isRtl ? -10 : 10, 0),
      child: LiquidBounceButton(
        onPressed: toggle.onPressed,
        icon: toggle.on ? Icons.videocam : Icons.videocam_off,
        bgColor: Colors.white.withValues(alpha: AppGlass.secondaryFillAlpha),
        size: 28,
        iconSize: 14,
        semanticLabel: context.l10n.homeCameraPreview,
        toggled: toggle.on,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sidebarWidth = constraints.maxWidth > AppSizes.sidebarWidth
            ? AppSizes.sidebarWidth
            : constraints.maxWidth;

        return Row(
          children: [
            SizedBox(
              width: sidebarWidth,
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
                        trailing: _buildCameraToggle(context),
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
            const Expanded(child: SizedBox.expand()),
          ],
        );
      },
    );
  }
}
