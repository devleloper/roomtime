import 'package:go_router/go_router.dart';
import '../../presentation/features/home/view/home_screen.dart';
import '../../presentation/features/room/view/room_screen.dart';
import '../../presentation/features/auth/view/auth_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/room/:roomName',
      builder: (context, state) {
        final roomName = state.pathParameters['roomName'] ?? 'unknown';
        return RoomScreen(roomName: roomName);
      },
    ),
  ],
);
