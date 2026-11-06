import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/view/room_exit_guard.dart';
import 'package:roomtime/presentation/features/room/widgets/call_banners.dart';
import 'package:roomtime/presentation/features/room/widgets/call_control_bar.dart';
import 'package:roomtime/presentation/features/room/widgets/call_notice.dart';
import 'package:roomtime/presentation/features/room/widgets/call_sheets.dart';
import 'package:roomtime/presentation/features/room/widgets/call_top_bar.dart';
import 'package:roomtime/presentation/features/room/widgets/call_video_layout.dart';
import 'package:roomtime/presentation/features/room/widgets/host_dialogs.dart';
import 'package:roomtime/presentation/features/room/widgets/media_shortcuts.dart';
import 'package:roomtime/presentation/features/room/widgets/participant_tile.dart';
import 'package:roomtime/presentation/features/room/widgets/participants_panel.dart'
    show runParticipantActions;
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CallView extends StatefulWidget {
  final Duration autoHideDelay;
  final RoomExitGuard? exitGuard;

  const CallView({
    super.key,
    this.autoHideDelay = AppMotion.chromeAutoHide,
    this.exitGuard,
  });

  @override
  State<CallView> createState() {
    return _CallViewState();
  }
}

class _CallViewState extends State<CallView> {
  late final RoomBloc _bloc = context.read<RoomBloc>();
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<RoomEffect> _effects;
  final _notices = CallNoticeController();

  bool _controlsVisible = true;
  Timer? _hideTimer;
  bool _barHasFocus = false;
  bool _barHovered = false;
  int _openOverlays = 0;
  bool _expiryDismissed = false;
  bool _showReconnected = false;
  bool _wasReconnecting = false;
  Timer? _reconnectedTimer;
  int _joinBurst = 0;
  Timer? _joinBurstTimer;

  @override
  void initState() {
    super.initState();
    _setWakelock(true);
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) => _bloc.add(RoomAppLifecycleChanged(state)),
    );
    _effects = _bloc.effects.listen(_onEffect);
    widget.exitGuard?.attach(_onHistoryExit);
    _scheduleHide();
  }

  @override
  void dispose() {
    widget.exitGuard?.detach(_onHistoryExit);
    _setWakelock(false);
    _lifecycle.dispose();
    _effects.cancel();
    _hideTimer?.cancel();
    _reconnectedTimer?.cancel();
    _joinBurstTimer?.cancel();
    _notices.dispose();
    if (isMobilePlatform) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  static Future<void> _setWakelock(bool on) async {
    try {
      await WakelockPlus.toggle(enable: on);
    } on Object catch (error) {
      devLog('wakelock unavailable: $error', name: 'CallView', error: error);
    }
  }

  void _onEffect(RoomEffect effect) {
    if (!mounted) {
      return;
    }
    switch (effect) {
      case ParticipantJoinedEffect(:final participant):
        _joinBurst++;
        _joinBurstTimer?.cancel();
        _joinBurstTimer = Timer(const Duration(seconds: 3), () {
          _joinBurst = 0;
        });
        _notices.show(
          _joinBurst > 1
              ? context.l10n.roomJoinedMany(_joinBurst)
              : context.l10n.roomJoined(participantName(context, participant)),
        );
      case ParticipantLeftEffect(:final participant):
        _notices.show(
          context.l10n.roomLeft(participantName(context, participant)),
        );
      case ParticipantMutedEffect(:final participant):
        _snack(context.l10n.roomMuted(_nameOrSomeone(participant)));
      case ParticipantRemovedEffect(:final participant):
        _snack(context.l10n.roomRemoved(_nameOrSomeone(participant)));
      case RoomSettingsChangedEffect(:final change):
        _snack(switch (change) {
          RoomSettingsChange.locked => context.l10n.roomLocked,
          RoomSettingsChange.unlocked => context.l10n.roomUnlocked,
          RoomSettingsChange.passwordSet => context.l10n.roomPasswordSet,
          RoomSettingsChange.passwordRemoved =>
            context.l10n.roomPasswordRemoved,
          RoomSettingsChange.inviteRotated => context.l10n.roomInviteRotated,
        });
      case RoomActionFailedEffect(:final failure):
        _snack(failure.localizedMessage(context.l10n));
    }
  }

  String _nameOrSomeone(CallParticipant? participant) {
    if (participant == null) {
      return context.l10n.roomSomeone;
    }
    return participantName(context, participant);
  }

  void _snack(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  bool _mayHide(RoomState state) {
    return isMobilePlatform &&
        !MediaQuery.accessibleNavigationOf(context) &&
        !_barHasFocus &&
        !_barHovered &&
        _openOverlays == 0 &&
        state is RoomConnected &&
        state.call.participants.length > 1;
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.autoHideDelay, () {
      if (!mounted || !_mayHide(_bloc.state)) {
        return;
      }
      _setControlsVisible(false);
    });
  }

  void _setControlsVisible(bool visible) {
    if (_controlsVisible == visible) {
      return;
    }
    setState(() => _controlsVisible = visible);
    if (isMobilePlatform) {
      SystemChrome.setEnabledSystemUIMode(
        visible ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
      );
    }
  }

  void _showControls() {
    _setControlsVisible(true);
    _scheduleHide();
  }

  void _toggleControls() {
    if (_controlsVisible) {
      if (_mayHide(_bloc.state)) {
        _setControlsVisible(false);
      }
    } else {
      _showControls();
    }
  }

  Future<T> _withOverlay<T>(Future<T> Function() open) async {
    setState(() => _openOverlays++);
    _setControlsVisible(true);
    try {
      return await open();
    } finally {
      if (mounted) {
        setState(() => _openOverlays--);
        _scheduleHide();
      }
    }
  }

  CallSnapshot get _call {
    final state = _bloc.state;
    return state is RoomInCall ? state.call : const CallSnapshot();
  }

  void _toggleMicrophone() {
    _bloc.add(RoomMicrophoneToggled(!_call.microphoneEnabled));
    _showControls();
  }

  void _toggleCamera() {
    _bloc.add(RoomCameraToggled(!_call.cameraEnabled));
    _showControls();
  }

  void _flipCamera() {
    _bloc.add(const RoomCameraFlipped());
    _showControls();
  }

  void _toggleSpeakerphone(bool on) {
    _bloc.add(RoomSpeakerphoneToggled(on));
    _showControls();
  }

  void _toggleParticipants() {
    _withOverlay(() => showParticipantsSheet(context));
  }

  void _invite() {
    _withOverlay(() => showCallInviteSheet(context));
  }

  Future<LeaveChoice?> _confirmLeave(RoomInCall state) async {
    if (!state.isHost) {
      return LeaveChoice.leave;
    }
    return _withOverlay(() => showHostLeaveFlow(context));
  }

  Future<void> _leave(RoomInCall state) async {
    switch (await _confirmLeave(state)) {
      case LeaveChoice.leave:
        _bloc.add(const RoomLeaveRequested());
      case LeaveChoice.end:
        _bloc.add(const RoomEndForAllRequested());
      case null:
        break;
    }
  }

  void _onBack() {
    final state = _bloc.state;
    if (state is RoomInCall && _openOverlays == 0) {
      _leave(state);
    }
  }

  Future<bool> _onHistoryExit() async {
    final state = _bloc.state;
    if (state is! RoomInCall || !mounted) {
      return true;
    }
    if (_openOverlays > 0) {
      return false;
    }
    switch (await _confirmLeave(state)) {
      case LeaveChoice.leave:
        return true;
      case LeaveChoice.end:
        _bloc.add(const RoomEndForAllRequested());
        return false;
      case null:
        return false;
    }
  }

  void _onParticipantLongPress(RoomInCall state, CallParticipant participant) {
    if (!state.isHost) {
      return;
    }
    _withOverlay(() => runParticipantActions(context, participant));
  }

  static int _people(RoomState state) {
    return state is RoomInCall ? state.call.participants.length : 0;
  }

  void _onStateChange(BuildContext context, RoomState state) {
    if (state is RoomReconnecting) {
      _wasReconnecting = true;
      _setControlsVisible(true);
      return;
    }
    if (state is! RoomConnected) {
      return;
    }
    if (_wasReconnecting) {
      _wasReconnecting = false;
      setState(() => _showReconnected = true);
      _reconnectedTimer?.cancel();
      _reconnectedTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _showReconnected = false);
        }
      });
    }
    _scheduleHide();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (_people(previous) > 1) != (_people(current) > 1),
      listener: _onStateChange,
      buildWhen: (previous, current) => current is RoomInCall,
      builder: (context, state) {
        if (state is! RoomInCall) {
          return const SizedBox.shrink();
        }
        return _buildCall(context, state);
      },
    );
  }

  Widget _buildCall(BuildContext context, RoomInCall state) {
    final visible = _controlsVisible || !_mayHide(state);
    final reduced = AppMotion.reduced(context);
    final duration = reduced
        ? Duration.zero
        : const Duration(milliseconds: 300);

    final stage = Stack(
      fit: StackFit.expand,
      children: [
        AnimatedOpacity(
          opacity: state is RoomReconnecting ? 0.6 : 1,
          duration: duration,
          child: CallVideoLayout(
            call: state.call,
            isHost: state.isHost,
            onBackgroundTap: _toggleControls,
            onParticipantLongPress: state.isHost
                ? (p) => _onParticipantLongPress(state, p)
                : null,
            aloneOverlay: CallAloneCard(inviteUrl: state.inviteUrl),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                CallTopBar.topInset,
                16,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CallTopBar(
                    state: state,
                    visible: visible,
                    fadeDuration: duration,
                    onToggleParticipants: _toggleParticipants,
                    onInvite: _invite,
                  ),
                  const SizedBox(height: 12),
                  CallBanners(
                    state: state,
                    showReconnected: _showReconnected,
                    expiryDismissed: _expiryDismissed,
                    onLeave: () => _bloc.add(const RoomLeaveRequested()),
                    onRetryMicrophone: () =>
                        _bloc.add(const RoomMicrophoneToggled(true)),
                    onStartAudio: () =>
                        _bloc.add(const RoomAudioPlaybackStartRequested()),
                    onDismissExpiry: () =>
                        setState(() => _expiryDismissed = true),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: visible ? 120 : 40,
          left: 16,
          right: 16,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: SafeArea(
            top: false,
            child: Center(child: CallNotice(controller: _notices)),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child: SafeArea(
            top: false,
            child: AnimatedSlide(
              offset: visible ? Offset.zero : const Offset(0, 1.5),
              duration: duration,
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: duration,
                child: IgnorePointer(
                  ignoring: !visible,
                  child: ExcludeSemantics(
                    excluding: !visible,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _barHovered = true),
                      onExit: (_) {
                        setState(() => _barHovered = false);
                        _scheduleHide();
                      },
                      child: Focus(
                        skipTraversal: true,
                        onFocusChange: (focused) {
                          setState(() => _barHasFocus = focused);
                          if (!focused) {
                            _scheduleHide();
                          }
                        },
                        child: CallControlBar(
                          state: state,
                          canSwitchAudioOutput: _bloc.canSwitchAudioOutput,
                          onToggleMicrophone: _toggleMicrophone,
                          onToggleCamera: _toggleCamera,
                          onFlipCamera: _flipCamera,
                          onToggleSpeakerphone: _toggleSpeakerphone,
                          onLeave: () => _leave(state),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final call = MediaShortcuts(
      onToggleMicrophone: _toggleMicrophone,
      onToggleCamera: _toggleCamera,
      onToggleParticipants: _toggleParticipants,
      onShowShortcuts: () => _withOverlay(() => showShortcutsHelp(context)),
      child: Focus(
        skipTraversal: true,
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (!visible) {
            _showControls();
          }
          return KeyEventResult.ignored;
        },
        child: Listener(
          onPointerHover: (_) {
            if (!_controlsVisible) {
              _showControls();
            }
          },
          child: Scaffold(backgroundColor: Colors.black, body: stage),
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onBack();
        }
      },
      child: call,
    );
  }
}
