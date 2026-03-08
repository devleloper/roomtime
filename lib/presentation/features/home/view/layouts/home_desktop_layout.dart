import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/custom_bounce_button.dart';
import '../../../../widgets/liquid_glass_container.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';

class HomeDesktopLayout extends StatelessWidget {
  final HomeState state;
  final List<Map<String, dynamic>> rooms;

  const HomeDesktopLayout({
    super.key,
    required this.state,
    required this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // Sidebar panel with frosted glass
            SizedBox(
              width: constraints.maxWidth > 380 ? 380 : constraints.maxWidth,
              child: LiquidGlassContainer(
                blur: 30,
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                borderColor: Colors.transparent,
                borderRadius: 0,
                child: SafeArea(
                  right: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'FamilyCalls',
                              style: TextStyle(
                                fontSize: 28, // Proportional to mobile's 34
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Using the exact same button style as mobile
                            _buildActionSection(context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rooms',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            _buildRefreshButton(context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: _buildRoomsList(context)),
                    ],
                  ),
                ),
              ),
            ),
            // Empty space for the sharp camera view
            Expanded(child: Container()),
          ],
        );
      },
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return CustomBounceButton(
      onPressed: () => context.read<HomeBloc>().add(FetchRooms()),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.refresh, color: Colors.white70, size: 14),
      ),
    );
  }

  // Identical to mobile single-button layout
  Widget _buildActionSection(BuildContext context) {
    return CustomBounceButton(
      borderRadius: 16,
      onPressed: () {
        final roomName =
            'Room-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        context.go('/room/$roomName?owner=true');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
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
                fontSize: 16,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            state.errorMessage ?? 'Failed to load rooms',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error, fontSize: 14),
          ),
        ),
      );
    } else if (rooms.isEmpty) {
      return const Center(
        child: Text(
          'No active rooms available.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: rooms.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _buildRoomTile(context, room['name'] ?? 'Unknown');
      },
    );
  }

  Widget _buildRoomTile(BuildContext context, String roomName) {
    return CustomBounceButton(
      borderRadius: 8,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
