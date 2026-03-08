import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/custom_bounce_button.dart';
import '../../../../widgets/liquid_glass_container.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';

class HomeMobileLayout extends StatelessWidget {
  final HomeState state;
  final List<Map<String, dynamic>> rooms;

  const HomeMobileLayout({super.key, required this.state, required this.rooms});

  @override
  Widget build(BuildContext context) {
    // We add a blur here because CameraBackgroundView no longer has a global blur,
    // and the mobile text needs to be readable over the raw camera.
    return Stack(
      children: [
        // Subtle background blur for text legibility on mobile
        LiquidGlassContainer(
          blur: 30,
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          borderColor: Colors.transparent,
          borderRadius: 0,
          child: Container(),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height:
                      (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS)
                      ? 48
                      : 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FamilyCalls',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    _buildRefreshButton(context),
                  ],
                ),
                const SizedBox(height: 24),
                _buildActionSection(context),
                const SizedBox(height: 32),
                Expanded(child: _buildRoomsList(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return CustomBounceButton(
      onPressed: () {
        context.read<HomeBloc>().add(FetchRooms());
      },
      child: LiquidGlassContainer(
        borderRadius: 100,
        blur: 12,
        backgroundColor: AppColors.surface.withValues(alpha: 0.4),
        borderColor: Colors.white.withValues(alpha: 0.15),
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.refresh, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return CustomBounceButton(
      borderRadius: 16,
      onPressed: () {
        final roomName =
            'Room-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        context.go('/room/$roomName?owner=true');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Create Room',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context) {
    if (state.status == HomeStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (state.status == HomeStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Failed to load rooms',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error, fontSize: 16),
        ),
      );
    } else if (rooms.isEmpty) {
      return const Center(
        child: Text(
          'No active rooms available.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: rooms.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.white24, height: 1),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _buildRoomTile(context, room['name'] ?? 'Unknown');
      },
    );
  }

  Widget _buildRoomTile(BuildContext context, String roomName) {
    return CustomBounceButton(
      borderRadius: 16,
      overlayOpacity: 0.0,
      onPressed: () {
        context.go('/room/$roomName');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'FamilyCalls Video',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
