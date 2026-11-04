import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../domain/entities/room.dart';
import '../../../../domain/entities/room_code.dart';
import '../bloc/lobby_cubit.dart';
import '../bloc/room_bloc.dart';
import 'call_view.dart';
import 'ended_view.dart';
import 'join_error_view.dart';
import 'lobby_view.dart';

/// Lets the room route ask before history navigation (browser Back, a new
/// URL) leaves a call (UX3-03). The call view attaches while it is shown; in
/// every other state the route may leave at once.
final class RoomExitGuard {
  Future<bool> Function()? _onExit;

  void attach(Future<bool> Function() onExit) => _onExit = onExit;

  void detach(Future<bool> Function() onExit) {
    if (_onExit == onExit) _onExit = null;
  }

  /// True when the route may leave now.
  Future<bool> mayExit() => _onExit?.call() ?? Future.value(true);
}

/// `/r/:code`: lobby → call → ended, one attempt at a time.
///
/// Each attempt gets a fresh [RoomBloc] and [LobbyCubit] from the factories
/// (the composition root passes them in), so "Rejoin" and "Try again" always
/// make a new join request, and closing the screen releases camera,
/// microphone and the media connection.
class RoomScreen extends StatefulWidget {
  const RoomScreen({
    super.key,
    required this.code,
    required this.createRoomBloc,
    required this.createLobbyCubit,
    this.summary,
    this.exitGuard,
  });

  final RoomCode code;

  /// Lookup result from Home; used for the first attempt only.
  final RoomSummary? summary;
  final RoomBloc Function() createRoomBloc;
  final LobbyCubit Function() createLobbyCubit;
  final RoomExitGuard? exitGuard;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int _attempt = 0;
  late RoomCode _code = widget.code;
  DeviceChoice _devices = (camera: true, microphone: true);

  void _newAttempt({RoomCode? code}) => setState(() {
    _attempt++;
    if (code != null) _code = code;
  });

  void _goHome() => context.go(AppRoutes.home);

  void _newRoom() => context.go(
    AppRoutes.home,
    extra: const HomeRouteExtra(openCreateSheet: true),
  );

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
          // System Back outside a call goes Home instead of closing the
          // app; in a call, CallView runs the Leave flow (UX3-03).
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

  Widget _body(RoomState state) => switch (state) {
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
