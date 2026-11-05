import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/room_code.dart';
import '../domain/services/media_preview.dart';
import '../presentation/features/home/bloc/home_bloc.dart';
import '../presentation/features/home/view/home_screen.dart';
import '../presentation/features/room/bloc/lobby_cubit.dart';
import '../presentation/features/room/bloc/room_bloc.dart';
import '../presentation/features/room/view/room_screen.dart';
import '../core/di/injection.dart';
import '../core/router/app_routes.dart';

/// One guard per room page, so browser history cannot drop a call silently.
final _roomExitGuards = <ValueKey<String>, RoomExitGuard>{};

/// Notice from the room guard (a malformed invite link) for Home.
final _homeNotices = PendingHomeNotice();

/// Route table and the presentation side of the composition root: the only
/// place besides `main.dart` that resolves blocs from the container.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        final extra = state.extra is HomeRouteExtra
            ? state.extra! as HomeRouteExtra
            : const HomeRouteExtra();
        return BlocProvider(
          create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
          child: HomeScreen(
            openCreateSheet: extra.openCreateSheet,
            notices: _homeNotices,
            createPreview: getIt.call<MediaPreview>,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.roomPattern,
      redirect: (context, state) => AppRoutes.roomRedirect(
        state.pathParameters['code'] ?? '',
        _homeNotices,
      ),
      onExit: (context, state) async {
        final guard = _roomExitGuards[state.pageKey];
        final exit = guard == null || await guard.mayExit();
        if (exit) _roomExitGuards.remove(state.pageKey);
        return exit;
      },
      builder: (context, state) {
        final code = RoomCode.tryParse(state.pathParameters['code']!)!;
        final extra = state.extra is RoomRouteExtra
            ? state.extra! as RoomRouteExtra
            : const RoomRouteExtra();
        return RoomScreen(
          code: code,
          summary: extra.summary?.code == code ? extra.summary : null,
          createRoomBloc: getIt.call<RoomBloc>,
          createLobbyCubit: getIt.call<LobbyCubit>,
          exitGuard: _roomExitGuards.putIfAbsent(
            state.pageKey,
            RoomExitGuard.new,
          ),
        );
      },
    ),
  ],
);
