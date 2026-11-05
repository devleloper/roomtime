import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../domain/entities/call_snapshot.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../theme/theme.dart';
import '../../../utils/failure_message.dart';
import '../../../widgets/widgets.dart';
import '../../../invite/invite_sharing.dart';
import '../bloc/room_bloc.dart';
import '../widgets/call_notice.dart';
import '../widgets/call_sheets.dart';
import '../widgets/call_video_layout.dart';
import '../widgets/dynamic_island_badge.dart';
import '../widgets/host_dialogs.dart';
import '../../../shared/platform.dart';
import '../widgets/media_controls.dart';
import '../widgets/media_shortcuts.dart';
import '../widgets/participant_tile.dart';
import '../widgets/participants_panel.dart' show runParticipantActions;
import 'room_screen.dart' show RoomExitGuard;
import '../../../../l10n/l10n.dart';

/// The call (flows.md §5-§8) in the dev-0.1.6 look: video full screen,
/// the room name badge at the top, the folding HUD and a bottom row of round
/// glass controls (mic, camera, flip on touch, speaker on phones, hang up);
/// Participants and Invite are glass circles in the top corners. Host
/// actions open the glass dialogs. Expects a [RoomBloc] in a [RoomInCall]
/// state.
class CallView extends StatefulWidget {
  const CallView({
    super.key,
    this.autoHideDelay = AppMotion.chromeAutoHide,
    this.exitGuard,
  });

  final Duration autoHideDelay;

  /// Asked by the route before browser history leaves the call.
  final RoomExitGuard? exitGuard;

  @override
  State<CallView> createState() => _CallViewState();
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
    // The bloc is provided by the route, above this State, so lifecycle
    // changes always reach it.
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
      developer.log('wakelock unavailable: $error', name: 'CallView');
    }
  }

  // Effects ------------------------------------------------------------------

  void _onEffect(RoomEffect effect) {
    if (!mounted) return;
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

  String _nameOrSomeone(CallParticipant? p) =>
      p == null ? context.l10n.roomSomeone : participantName(context, p);

  void _snack(String message) => ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  // Controls visibility -------------------------------------------------------

  /// Auto-hide only on touch devices, and never while a screen reader is on,
  /// focus or the pointer is in the bar, an overlay is open, the connection
  /// is being restored or the user is alone (flows.md §5).
  bool _mayHide(RoomState state) =>
      isMobilePlatform &&
      !MediaQuery.accessibleNavigationOf(context) &&
      !_barHasFocus &&
      !_barHovered &&
      _openOverlays == 0 &&
      state is RoomConnected &&
      state.call.participants.length > 1;

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.autoHideDelay, () {
      if (!mounted || !_mayHide(_bloc.state)) return;
      _setControlsVisible(false);
    });
  }

  void _setControlsVisible(bool visible) {
    if (_controlsVisible == visible) return;
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
      if (_mayHide(_bloc.state)) _setControlsVisible(false);
    } else {
      _showControls();
    }
  }

  /// Keeps the controls up while an overlay (sheet, dialog) is open.
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

  // Actions ------------------------------------------------------------------

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

  void _toggleParticipants() =>
      _withOverlay(() => showParticipantsSheet(context));

  void _invite() => _withOverlay(() => showCallInviteSheet(context));

  /// The Leave flow (flows.md §7): a participant leaves at once, the host
  /// chooses between leaving and ending the call. Null when cancelled.
  Future<LeaveChoice?> _confirmLeave(RoomInCall state) async {
    if (!state.isHost) return LeaveChoice.leave;
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

  /// System Back: the same flow as the Leave button.
  void _onBack() {
    final state = _bloc.state;
    if (state is RoomInCall && _openOverlays == 0) _leave(state);
  }

  /// Browser history: leaving lets the route go (the closing bloc leaves the
  /// call); ending for everyone stays to show the result.
  Future<bool> _onHistoryExit() async {
    final state = _bloc.state;
    if (state is! RoomInCall || !mounted) return true;
    // A sheet or dialog is already open: stay, it is the user's next step.
    if (_openOverlays > 0) return false;
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

  void _onParticipantLongPress(RoomInCall state, CallParticipant p) {
    if (!state.isHost) return;
    _withOverlay(() => runParticipantActions(context, p));
  }

  // Build ---------------------------------------------------------------------

  static int _people(RoomState state) =>
      state is RoomInCall ? state.call.participants.length : 0;

  void _onStateChange(BuildContext context, RoomState state) {
    if (state is RoomReconnecting) {
      _wasReconnecting = true;
      _setControlsVisible(true);
      return;
    }
    if (state is! RoomConnected) return;
    if (_wasReconnecting) {
      _wasReconnecting = false;
      setState(() => _showReconnected = true);
      _reconnectedTimer?.cancel();
      _reconnectedTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showReconnected = false);
      });
    }
    // Hiding may have become possible (someone joined, the connection is
    // back): restart the idle timer, it does not re-arm itself.
    _scheduleHide();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: BlocConsumer<RoomBloc, RoomState>(
        listenWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType ||
            (_people(previous) > 1) != (_people(current) > 1),
        listener: _onStateChange,
        buildWhen: (previous, current) => current is RoomInCall,
        builder: (context, state) {
          if (state is! RoomInCall) return const SizedBox.shrink();
          return _buildCall(context, state);
        },
      ),
    );
  }

  Widget _buildCall(BuildContext context, RoomInCall state) {
    final visible = _controlsVisible || !_mayHide(state);
    final reduced = AppMotion.reduced(context);
    final duration = reduced
        ? Duration.zero
        : const Duration(milliseconds: 300);
    final people = state.call.participants.length;

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
            aloneOverlay: _AloneCard(inviteUrl: state.inviteUrl),
          ),
        ),
        // Top: Participants, the room name badge, Invite.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              // 0.1.6 badge: safeTop + 16.
              padding: const EdgeInsets.fromLTRB(16, _topInset, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        // Keeps the badge clear of the corner circles.
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: _TopBar(state: state, visible: visible),
                      ),
                      Row(
                        children: [
                          _fade(
                            visible: visible,
                            duration: duration,
                            child: MediaControlButton(
                              icon: Icons.group,
                              label:
                                  '${context.l10n.roomParticipants}, '
                                  '${context.l10n.roomParticipantCount(people)}',
                              tooltip: context.l10n.roomParticipants,
                              size: 48,
                              onPressed: _toggleParticipants,
                            ),
                          ),
                          const Spacer(),
                          _fade(
                            visible: visible,
                            duration: duration,
                            child: MediaControlButton(
                              icon: Icons.person_add,
                              label: context.l10n.roomInvite,
                              size: 48,
                              onPressed: _invite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._banners(state),
                ],
              ),
            ),
          ),
        ),
        // The folding HUD: 120 above the bottom with the controls, 40
        // without them.
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
              child: _fade(
                visible: visible,
                duration: duration,
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
                      if (!focused) _scheduleHide();
                    },
                    child: _mediaControls(state),
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
          // Any key brings the controls back; the key itself goes on.
          if (!visible) _showControls();
          return KeyEventResult.ignored;
        },
        child: Listener(
          onPointerHover: (_) {
            if (!_controlsVisible) _showControls();
          },
          child: Scaffold(backgroundColor: Colors.black, body: stage),
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: call,
    );
  }

  /// The 0.1.6 control row: mic, camera, flip (touch), speaker (phones),
  /// hang up. Off and destructive controls are tinted red.
  Widget _mediaControls(RoomInCall state) {
    final call = state.call;
    final mic = call.microphoneEnabled;
    final camera = call.cameraEnabled;
    final speakerOn = call.speakerphoneOn;
    return MediaControlsRow(
      buttons: [
        (size) => MediaControlButton.microphone(
          context,
          on: mic,
          size: size,
          onPressed: _toggleMicrophone,
        ),
        (size) => MediaControlButton.camera(
          context,
          on: camera,
          size: size,
          onPressed: _toggleCamera,
        ),
        // Phones and tablets, mobile browsers included.
        if (isTouchPlatform)
          (size) => MediaControlButton(
            icon: Icons.cameraswitch,
            label: context.l10n.roomFlip,
            size: size,
            onPressed: camera
                ? () {
                    _bloc.add(const RoomCameraFlipped());
                    _showControls();
                  }
                : null,
          ),
        if (_bloc.canSwitchAudioOutput)
          (size) => MediaControlButton(
            icon: speakerOn ? Icons.volume_up : Icons.phone_in_talk,
            label: speakerOn
                ? context.l10n.roomSpeaker
                : context.l10n.roomEarpiece,
            tooltip: speakerOn
                ? context.l10n.roomSwitchToEarpiece
                : context.l10n.roomSwitchToSpeaker,
            size: size,
            onPressed: () {
              _bloc.add(RoomSpeakerphoneToggled(!speakerOn));
              _showControls();
            },
          ),
        (size) => MediaControlButton(
          icon: Icons.call_end,
          label: context.l10n.roomLeave,
          red: true,
          size: size,
          onPressed: () => _leave(state),
        ),
      ],
    );
  }

  Widget _fade({
    required bool visible,
    required Duration duration,
    required Widget child,
  }) => AnimatedOpacity(
    opacity: visible ? 1 : 0,
    duration: duration,
    child: IgnorePointer(
      ignoring: !visible,
      child: ExcludeSemantics(excluding: !visible, child: child),
    ),
  );

  List<Widget> _banners(RoomInCall state) {
    final expiresAt = state.room.expiresAt;
    return [
      if (state is RoomReconnecting)
        _GlassNotice(
          message: context.l10n.roomReconnecting,
          icon: Icons.wifi_off,
          showProgress: true,
          actionLabel: context.l10n.roomLeave,
          onAction: () => _bloc.add(const RoomLeaveRequested()),
        )
      else if (_showReconnected)
        _GlassNotice(message: context.l10n.roomReconnected, icon: Icons.wifi),
      if (state.call.microphoneUnavailable)
        _GlassNotice(
          message: kIsWeb
              ? context.l10n.roomMicUnavailableWeb
              : context.l10n.roomMicUnavailable,
          icon: Icons.mic_off,
          actionLabel: context.l10n.roomTryAgain,
          onAction: () => _bloc.add(const RoomMicrophoneToggled(true)),
        ),
      if (state.call.audioPlaybackBlocked)
        _GlassNotice(
          message: context.l10n.roomSoundBlocked,
          icon: Icons.volume_up,
          actionLabel: context.l10n.roomTurnOnSound,
          onAction: () => _bloc.add(const RoomAudioPlaybackStartRequested()),
        ),
      if (state.isHost && state.expiresSoon && !_expiryDismissed)
        _GlassNotice(
          message: context.l10n.roomExpiresSoon(
            TimeOfDay.fromDateTime(expiresAt.toLocal()).format(context),
          ),
          icon: Icons.timer_outlined,
          actionLabel: context.l10n.roomDismiss,
          onAction: () => setState(() => _expiryDismissed = true),
        ),
    ];
  }
}

/// A state line in the 0.1.6 HUD glass (blur 12, white @ 0.1 rim), with an
/// optional text action. Announced when it appears. Tinted black @ 0.8 (the
/// banner tint; 0.1.6: 0.5) and the action white, underlined: both keep
/// 4.5:1 over a bright frame.
class _GlassNotice extends StatelessWidget {
  const _GlassNotice({
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.showProgress = false,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LiquidGlassContainer(
            blur: 12,
            borderRadius: 24,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            borderColor: Colors.white.withValues(alpha: 0.1),
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                if (showProgress)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The room name badge ([DynamicIslandBadge]): on iPhones with a Dynamic
/// Island in portrait it grows out of the island; elsewhere it slides in.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.visible});

  final RoomInCall state;
  final bool visible;

  /// Heuristic: iOS app, portrait, a status bar inset of an island device.
  static bool _hasIsland(BuildContext context) {
    final media = MediaQuery.of(context);
    return !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        media.orientation == Orientation.portrait &&
        media.padding.top >= 59;
  }

  @override
  Widget build(BuildContext context) {
    final name = state.room.name;
    final title = name == null || name.isEmpty
        ? context.l10n.roomTitleUnnamed(state.room.code.display)
        : name;
    final island = _hasIsland(context);
    final safeTop = MediaQuery.paddingOf(context).top;
    return Center(
      child: Semantics(
        header: true,
        child: DynamicIslandBadge(
          roomName: title,
          isVisible: visible,
          hasDynamicIsland: island,
          islandOffset: island
              ? AppSizes.dynamicIslandTop - (safeTop + _topInset)
              : 0,
        ),
      ),
    );
  }
}

/// "You're the only one here" with Copy link and Share (flows.md §5), in
/// the glass dialog panel.
/// Gap between the safe top and the room name badge (0.1.6).
const double _topInset = 16;

class _AloneCard extends StatelessWidget {
  const _AloneCard({required this.inviteUrl});

  final Uri inviteUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GlassPanel(
        tintAlpha: GlassPanel.overVideoTintAlpha,
        child: GlassDialogContent(
          title: context.l10n.roomAlone,
          message: context.l10n.roomAloneBody,
          actions: [
            GlassDialogButton(
              label: context.l10n.inviteCopyLink,
              icon: Icons.link,
              onPressed: () => copyWithConfirmation(
                context,
                inviteUrl.toString(),
                context.l10n.inviteLinkCopied,
              ),
            ),
            Builder(
              builder: (buttonContext) => GlassDialogButton(
                label: context.l10n.inviteShare,
                icon: Icons.ios_share,
                style: GlassButtonStyle.primary,
                onPressed: () => shareInvite(buttonContext, inviteUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
