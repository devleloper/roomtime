import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/camera_background_view.dart';
import 'layouts/home_desktop_layout.dart';
import 'layouts/home_mobile_layout.dart';

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
          final rooms = state.rooms.reversed.toList(); // Newest first

          final isPhone =
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                const Positioned.fill(child: CameraBackgroundView()),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTabletOrDesktop = constraints.maxWidth > 600;

                    if (isPhone && !isTabletOrDesktop) {
                      return HomeMobileLayout(state: state, rooms: rooms);
                    }

                    return HomeDesktopLayout(state: state, rooms: rooms);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
