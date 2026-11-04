import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/guest_profile.dart';
import '../../../../domain/entities/room.dart';
import '../../../../domain/entities/room_code.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/services/media_preview.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../theme/theme.dart';
import '../../../utils/failure_message.dart';
import '../../../widgets/widgets.dart';
import '../../../invite/invite_panel.dart';
import '../bloc/lobby_cubit.dart';
import '../bloc/room_bloc.dart';
import '../widgets/media_controls.dart';
import '../widgets/media_shortcuts.dart';
import '../../../shared/participant_video.dart';
import '../../../shared/platform.dart';
import 'join_error_view.dart';
import '../../../../l10n/l10n.dart';

/// Device choices the user joined with, kept for "Rejoin".
typedef DeviceChoice = ({bool camera, bool microphone});

/// Pre-join (flows.md §4): preview, devices, name and password. The password
/// lives here because only the join request can verify it (ADR-0003).
/// Expects a [LobbyCubit] and a [RoomBloc] above it.
class LobbyView extends StatelessWidget {
  const LobbyView({
    super.key,
    required this.code,
    required this.onHome,
    required this.onJoining,
  });

  final RoomCode code;
  final VoidCallback onHome;
  final ValueChanged<DeviceChoice> onJoining;

  @override
  Widget build(BuildContext context) {
    final lobby = context.read<LobbyCubit>();
    return BlocBuilder<LobbyCubit, LobbyState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => switch (state.status) {
        LobbyStatus.loading => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              semanticsLabel: context.l10n.roomFinding,
            ),
          ),
        ),
        LobbyStatus.notFound => JoinErrorView(
          failure: const RoomNotFoundFailure(),
          onHome: onHome,
        ),
        LobbyStatus.failed => JoinErrorView(
          failure: state.failure ?? const UnknownFailure(),
          onHome: onHome,
          onRetry: lobby.retry,
        ),
        LobbyStatus.ready => _LobbyForm(
          code: code,
          onHome: onHome,
          onJoining: onJoining,
        ),
      },
    );
  }
}

class _LobbyForm extends StatefulWidget {
  const _LobbyForm({
    required this.code,
    required this.onHome,
    required this.onJoining,
  });

  final RoomCode code;
  final VoidCallback onHome;
  final ValueChanged<DeviceChoice> onJoining;

  @override
  State<_LobbyForm> createState() => _LobbyFormState();
}

class _LobbyFormState extends State<_LobbyForm> {
  static const _defaultLockout = Duration(seconds: 60);

  late final LobbyCubit _lobby = context.read<LobbyCubit>();
  late final RoomBloc _room = context.read<RoomBloc>();
  late final _name = TextEditingController(text: _lobby.state.displayName);
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  late bool _needsPassword =
      !_lobby.state.isHost && (_lobby.state.summary?.passwordRequired ?? false);
  String? _nameError;
  String? _passwordError;
  Failure? _inlineFailure;
  int _lockoutSeconds = 0;

  /// Read once by screen readers: the live region keeps the time from when
  /// the lock-out started instead of announcing every tick (UX3-04).
  String? _lockoutAnnouncement;
  Timer? _lockoutTimer;
  bool _announceRetry = false;

  /// Set from the Join tap until the attempt fails: the preview is being
  /// released or the call is connecting, so no device control may reopen
  /// the camera (CR3-1).
  bool _joining = false;

  /// Keyboard-first devices focus the empty name field; otherwise the lobby
  /// shortcuts take focus, so Ctrl/⌘+D and +E work at once (CR3-5). Touch
  /// devices, mobile web included, never autofocus a field (UX3-11).
  late final bool _autofocusName = !isTouchPlatform && _name.text.isEmpty;

  /// Access may have changed in the system settings meanwhile (CR4-1).
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (!_isJoining) unawaited(_lobby.refreshAccess());
      },
    );
    _name.addListener(_rebuild);
    _password.addListener(_rebuild);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _lockoutTimer?.cancel();
    _name.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  bool get _isJoining => _joining || _room.state is RoomConnecting;

  bool get _canJoin =>
      !_isJoining &&
      _lockoutSeconds == 0 &&
      GuestProfile.normalizeDisplayName(_name.text) != null &&
      (!_needsPassword || _password.text.isNotEmpty);

  Future<void> _join() async {
    final name = GuestProfile.normalizeDisplayName(_name.text);
    if (name == null) {
      setState(
        () => _nameError = _name.text.trim().isEmpty
            ? context.l10n.roomNameRequired
            : context.l10n.roomNameTooLong,
      );
      return;
    }
    if (!_canJoin) return;
    final preview = _lobby.state.preview;
    final camera =
        preview.cameraEnabled && preview.cameraAccess != DeviceAccess.denied;
    final microphone =
        preview.microphoneEnabled &&
        preview.microphoneAccess != DeviceAccess.denied;
    setState(() {
      _joining = true;
      _nameError = null;
      _passwordError = null;
      _inlineFailure = null;
      _announceRetry = false;
    });
    widget.onJoining((
      camera: preview.cameraEnabled,
      microphone: preview.microphoneEnabled,
    ));
    // The call opens its own camera; the preview releases it first.
    await _lobby.releaseDevices();
    if (!mounted) return;
    _room.add(
      RoomJoinRequested(
        code: widget.code,
        password: _needsPassword ? _password.text : null,
        microphoneEnabled: microphone,
        cameraEnabled: camera,
        displayName: name,
      ),
    );
  }

  void _onRoomState(BuildContext context, RoomState state) {
    if (state is! RoomFailed || isFullScreenJoinFailure(state.failure)) return;
    final failure = state.failure;
    setState(() {
      _joining = false;
      switch (failure) {
        case PasswordRequiredFailure():
          _needsPassword = true;
          _passwordError = context.l10n.roomPasswordRequired;
          _focusPassword();
        case InvalidPasswordFailure():
          _needsPassword = true;
          _passwordError = context.l10n.roomWrongPassword;
          // QA D4: typing starts from an empty field on every platform.
          _password.clear();
          _focusPassword();
        case TooManyAttemptsFailure(:final retryAfter):
          _startLockout(retryAfter ?? _defaultLockout);
        case InvalidInputFailure(field: InputField.displayName):
          _nameError = failure.localizedMessage(context.l10n);
        case InvalidInputFailure(field: InputField.password):
          _passwordError = failure.localizedMessage(context.l10n);
        default:
          _inlineFailure = failure;
      }
    });
    unawaited(_lobby.resumeDevices());
  }

  void _focusPassword() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _passwordFocus.requestFocus();
    });
  }

  void _startLockout(Duration duration) {
    _lockoutTimer?.cancel();
    _lockoutSeconds = duration.inSeconds.clamp(1, 24 * 3600);
    _lockoutAnnouncement = context.l10n.roomTooManyAttempts(
      _mmss(_lockoutSeconds),
    );
    _announceRetry = false;
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() {
        _lockoutSeconds--;
        if (_lockoutSeconds <= 0) {
          _lockoutSeconds = 0;
          _announceRetry = true;
          timer.cancel();
        }
      });
    });
  }

  static String _mmss(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: _onRoomState,
      child: BlocBuilder<LobbyCubit, LobbyState>(
        builder: (context, state) => BlocBuilder<RoomBloc, RoomState>(
          builder: (context, _) => _buildForm(context, state),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, LobbyState state) {
    final summary = state.summary!;
    final roomName = summary.name;
    final title = roomName == null || roomName.isEmpty
        ? context.l10n.roomTitleUnnamed(summary.code.display)
        : roomName;
    final preview = state.preview;
    final joining = _isJoining;
    void toggleMicrophone() {
      if (!_isJoining) _lobby.setMicrophoneEnabled(!preview.microphoneEnabled);
    }

    void toggleCamera() {
      if (!_isJoining) _lobby.setCameraEnabled(!preview.cameraEnabled);
    }

    final name =
        GuestProfile.normalizeDisplayName(_name.text) ??
        GuestProfile.defaultDisplayName;

    return MediaShortcuts(
      autofocus: !_autofocusName,
      onToggleMicrophone: toggleMicrophone,
      onToggleCamera: toggleCamera,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _LobbyBackdrop(preview: preview, name: name),
            // No veil over the preview (F5): the user checks the camera
            // here. Only the panel is frosted, with a darker tint so its
            // text reads over a bright frame. Wide windows put it on the
            // start side like the Home sidebar, phones at the bottom.
            // The band under the back button is outside the scroll view,
            // so the scrolled card never slides beneath it (QA D8).
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: _backButtonBand),
                child: LayoutBuilder(
                  builder: (context, constraints) => Align(
                    alignment: constraints.maxWidth > 600
                        ? AlignmentDirectional.centerStart
                        : Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: glassDialogMaxWidth,
                        ),
                        child: GlassPanel(
                          tintAlpha: GlassPanel.overVideoTintAlpha,
                          child: _details(
                            context,
                            state,
                            title,
                            joining: joining,
                            onToggleMicrophone: toggleMicrophone,
                            onToggleCamera: toggleCamera,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: LiquidBounceButton(
                    onPressed: widget.onHome,
                    icon: Icons.arrow_back,
                    bgColor: AppColors.surface.withValues(alpha: 0.4),
                    size: 48,
                    iconSize: 24,
                    semanticLabel: context.l10n.roomBack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Permission explainer and "blocked" notices.
  List<Widget> _deviceNotices(
    BuildContext context,
    MediaPreviewState preview,
    bool joining,
  ) {
    final settings = _lobby.canOpenSettings;
    final micBlocked =
        preview.microphoneEnabled &&
        preview.microphoneAccess == DeviceAccess.denied;
    return [
      if (preview.needsPermissionPrompt && !joining)
        _Notice(
          text: context.l10n.roomPermExplainer,
          actionLabel: context.l10n.roomPermAllow,
          onAction: _lobby.requestAccess,
        ),
      if (preview.cameraEnabled && preview.cameraAccess == DeviceAccess.denied)
        _Notice(
          text: settings
              ? context.l10n.roomCameraBlocked
              : kIsWeb
              ? context.l10n.roomCameraBlockedWeb
              : context.l10n.roomCameraBlockedDesktop,
          actionLabel: settings ? context.l10n.roomOpenSettings : null,
          onAction: settings ? _lobby.openSettings : null,
        ),
      if (micBlocked)
        _Notice(
          text: settings
              ? context.l10n.roomMicBlocked
              : kIsWeb
              ? context.l10n.roomMicBlockedWeb
              : context.l10n.roomMicBlockedDesktop,
          actionLabel: settings ? context.l10n.roomOpenSettings : null,
          onAction: settings ? _lobby.openSettings : null,
        ),
    ];
  }

  Widget _details(
    BuildContext context,
    LobbyState state,
    String title, {
    required bool joining,
    required VoidCallback onToggleMicrophone,
    required VoidCallback onToggleCamera,
  }) {
    final preview = state.preview;
    final summary = state.summary!;
    final micOn = preview.microphoneEnabled;
    final cameraOn = preview.cameraEnabled;
    final notices = _deviceNotices(context, preview, joining);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassDialogTitle(title),
        if (state.isHost) ...[
          const SizedBox(height: 8),
          GlassDialogText(
            context.l10n.roomHostNotice,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          InvitePanel(
            code: summary.code,
            inviteUrl: summary.inviteUrl,
            passwordProtected: summary.passwordRequired,
          ),
        ] else if (summary.locked) ...[
          const SizedBox(height: 8),
          GlassDialogText(
            context.l10n.roomLockedNotice,
            textAlign: TextAlign.center,
          ),
        ],
        for (final notice in notices) ...[const SizedBox(height: 16), notice],
        const SizedBox(height: 24),
        GlassTextField(
          controller: _name,
          label: context.l10n.roomNameLabel,
          errorText: _nameError,
          maxLength: GuestProfile.maxDisplayNameLength,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          textInputAction: _needsPassword
              ? TextInputAction.next
              : TextInputAction.go,
          enabled: !joining,
          autofocus: _autofocusName,
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
          onSubmitted: (_) {
            if (_needsPassword) {
              _passwordFocus.requestFocus();
            } else {
              _join();
            }
          },
        ),
        if (_needsPassword) ...[
          const SizedBox(height: 16),
          // No autofill (SEC-23): a saved password would be offered for
          // every room on this origin.
          GlassTextField(
            controller: _password,
            focusNode: _passwordFocus,
            label: context.l10n.roomPasswordLabel,
            helperText: _passwordError == null
                ? context.l10n.roomPasswordHelper
                : null,
            errorText: _passwordError,
            obscure: true,
            maxLength: RoomPassword.maxLength,
            textInputAction: TextInputAction.go,
            enabled: !joining,
            onChanged: (_) {
              if (_passwordError != null) {
                setState(() => _passwordError = null);
              }
            },
            onSubmitted: (_) => _join(),
          ),
        ],
        if (_inlineFailure case final failure?) ...[
          const SizedBox(height: 16),
          GlassErrorText(
            failure.localizedMessage(context.l10n),
            textAlign: TextAlign.center,
          ),
        ],
        if (_lockoutSeconds > 0) ...[
          const SizedBox(height: 16),
          // Announced once; the ticking digits are not a live region.
          Semantics(
            liveRegion: true,
            label: _lockoutAnnouncement,
            child: ExcludeSemantics(
              child: Text(
                context.l10n.roomTooManyAttempts(_mmss(_lockoutSeconds)),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 14),
              ),
            ),
          ),
        ] else if (_announceRetry) ...[
          const SizedBox(height: 16),
          Semantics(
            liveRegion: true,
            child: GlassDialogText(
              context.l10n.roomCanTryAgain,
              textAlign: TextAlign.center,
            ),
          ),
        ],
        const SizedBox(height: 24),
        MediaControlsRow(
          buttons: [
            (size) => MediaControlButton.microphone(
              context,
              on: micOn,
              size: size,
              onPressed: joining ? null : onToggleMicrophone,
            ),
            (size) => MediaControlButton.camera(
              context,
              on: cameraOn,
              size: size,
              onPressed: joining ? null : onToggleCamera,
            ),
          ],
        ),
        const SizedBox(height: 32),
        GlassButtonRow(
          children: [
            GlassDialogButton(
              label: context.l10n.roomCancel,
              onPressed: widget.onHome,
            ),
            GlassDialogButton(
              label: joining ? context.l10n.roomJoining : context.l10n.roomJoin,
              style: GlassButtonStyle.primary,
              isLoading: joining,
              onPressed: _canJoin ? _join : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// White70 notice with an optional secondary glass button.
class _Notice extends StatelessWidget {
  const _Notice({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Semantics(
        liveRegion: true,
        child: GlassDialogText(text, textAlign: TextAlign.center),
      ),
      if (actionLabel != null && onAction != null) ...[
        const SizedBox(height: 8),
        GlassDialogButton(label: actionLabel!, onPressed: onAction),
      ],
    ],
  );
}

/// The local camera behind the lobby veil, or black with the avatar.
class _LobbyBackdrop extends StatelessWidget {
  const _LobbyBackdrop({required this.preview, required this.name});

  final MediaPreviewState preview;
  final String name;

  @override
  Widget build(BuildContext context) {
    final cameraOn = preview.cameraEnabled;
    final showVideo = cameraOn && preview.videoTrack != null;
    return Semantics(
      container: true,
      label: cameraOn
          ? context.l10n.roomPreviewOn
          : context.l10n.roomPreviewOff,
      child: showVideo
          ? ParticipantVideo(videoTrack: preview.videoTrack, name: name)
          : const ColoredBox(color: Colors.black),
    );
  }
}

/// Back button inset (16) + size (48) + a gap (8).
const double _backButtonBand = 72;
