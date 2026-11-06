import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomtime/core/di/injection.dart';
import 'package:roomtime/core/router/app_routes.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/presentation/features/home/bloc/home_bloc.dart';
import 'package:roomtime/presentation/features/home/view/home_screen.dart';
import 'package:roomtime/presentation/features/room/bloc/lobby_cubit.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/view/room_screen.dart';

final _roomExitGuards = <ValueKey<String>, RoomExitGuard>{};

final _homeNotices = PendingHomeNotice();

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
      redirect: (context, state) {
        final rawCode = state.pathParameters['code'] ?? '';
        return AppRoutes.roomRedirect(rawCode, _homeNotices);
      },
      onExit: (context, state) async {
        final guard = _roomExitGuards[state.pageKey];
        final canExit = guard == null || await guard.mayExit();
        if (canExit) {
          _roomExitGuards.remove(state.pageKey);
        }
        return canExit;
      },
      builder: (context, state) {
        final code = RoomCode.tryParse(state.pathParameters['code']!)!;
        final extra = state.extra is RoomRouteExtra
            ? state.extra! as RoomRouteExtra
            : const RoomRouteExtra();
        final matchingSummary = extra.summary?.code == code
            ? extra.summary
            : null;
        final exitGuard = _roomExitGuards.putIfAbsent(
          state.pageKey,
          RoomExitGuard.new,
        );

        return RoomScreen(
          code: code,
          summary: matchingSummary,
          createRoomBloc: getIt.call<RoomBloc>,
          createLobbyCubit: getIt.call<LobbyCubit>,
          exitGuard: exitGuard,
        );
      },
    ),
  ],
);
