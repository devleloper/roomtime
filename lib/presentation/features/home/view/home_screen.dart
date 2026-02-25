import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bounce_button.dart';
import '../../../../core/di/injection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/camera_background_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(FetchRooms()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                const Positioned.fill(child: CameraBackgroundView()),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
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
                            IconButton(
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context.read<HomeBloc>().add(FetchRooms());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildActionSection(context),
                        const SizedBox(height: 32),
                        Expanded(
                          child: state.status == HomeStatus.loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : state.status == HomeStatus.failure
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Text(
                                      state.errorMessage ??
                                          'Failed to load rooms',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : state.rooms.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No active rooms available.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  itemCount: state.rooms.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                        color: Colors.white24,
                                        height: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    final room = state.rooms[index];
                                    return _buildRoomTile(
                                      context,
                                      room['name'] ?? 'Unknown',
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return CustomBounceButton(
      borderRadius: 16,
      onPressed: () {
        final roomName =
            'Room-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

        // Push the route, wait 350ms before heavy components bind native plugins to avoid animation jank
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

  Widget _buildRoomTile(BuildContext context, String roomName) {
    return CustomBounceButton(
      borderRadius: 16,
      overlayOpacity: 0.0,
      onPressed: () {
        context.go('/room/$roomName');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.transparent, // Ensure button hit area is full width
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
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.videocam, color: Colors.white60, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'FamilyCalls Video',
                        style: TextStyle(fontSize: 14, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.info_outline, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
