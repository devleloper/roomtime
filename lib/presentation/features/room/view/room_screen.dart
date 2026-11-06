import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomtime/core/router/app_routes.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/presentation/features/room/bloc/lobby_cubit.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/view/call_view.dart';
import 'package:roomtime/presentation/features/room/view/ended_view.dart';
import 'package:roomtime/presentation/features/room/view/join_error_view.dart';
import 'package:roomtime/presentation/features/room/view/lobby_view.dart';
import 'package:roomtime/presentation/features/room/view/room_exit_guard.dart';

export 'package:roomtime/presentation/features/room/view/room_exit_guard.dart';

class RoomScreen extends StatefulWidget {
  final RoomCode code;

  final RoomSummary? summary;
  final RoomBloc Function() createRoomBloc;
  final LobbyCubit Function() createLobbyCubit;
  final RoomExitGuard? exitGuard;

  const RoomScreen({
    super.key,
    required this.code,
    required this.createRoomBloc,
    required this.createLobbyCubit,
    this.summary,
    this.exitGuard,
  });

  @override
  State<RoomScreen> createState() {
    return _RoomScreenState();
  }
}

class _RoomScreenState extends State<RoomScreen> {
  int _attempt = 0;
  late RoomCode _code = widget.code;
  DeviceChoice _devices = (camera: true, microphone: true);

  void _newAttempt({RoomCode? code}) {
    setState(() {
      _attempt++;
      if (code != null) {
        _code = code;
      }
    });
  }

  void _goHome() {
    context.go(AppRoutes.home);
  }

  void _newRoom() {
    context.go(
      AppRoutes.home,
      extra: const HomeRouteExtra(openCreateSheet: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = _attempt == 0 ? widget.summary : null;
    return MultiBlocProvider(
      key: ValueKey(_attempt),
      providers: [
        BlocProvider(create: (_) => widget.createRoomBloc()),
        BlocProvider(
          create: (_) => widget.createLobbyCubit()
            ..start(
              _code,
              summary: summary,
              camera: _devices.camera,
              microphone: _devices.microphone,
            ),
        ),
      ],
      child: BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType ||
            current is RoomFailed ||
            current is RoomEnded,
        builder: (context, state) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && context.read<RoomBloc>().state is! RoomInCall) {
              _goHome();
            }
          },
          child: _body(state),
        ),
      ),
    );
  }

  Widget _body(RoomState state) {
    return switch (state) {
      RoomInCall() => CallView(exitGuard: widget.exitGuard),
      RoomEnded(:final reason, :final endedByYou, :final code) => EndedView(
        reason: reason,
        endedByYou: endedByYou,
        onRejoin: () => _newAttempt(code: code),
        onHome: _goHome,
        onNewRoom: _newRoom,
      ),
      RoomFailed(:final failure) when isFullScreenJoinFailure(failure) =>
        JoinErrorView(failure: failure, onHome: _goHome, onRetry: _newAttempt),
      RoomInitial() || RoomConnecting() || RoomFailed() => LobbyView(
        code: _code,
        onHome: _goHome,
        onJoining: (devices) => _devices = devices,
      ),
    };
  }
}
