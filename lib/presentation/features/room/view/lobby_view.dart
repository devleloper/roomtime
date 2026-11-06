import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/entities/room_password.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/lobby_cubit.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/view/join_error_view.dart';
import 'package:roomtime/presentation/features/room/widgets/lobby_device_notices.dart';
import 'package:roomtime/presentation/features/room/widgets/media_controls.dart';
import 'package:roomtime/presentation/features/room/widgets/media_shortcuts.dart';
import 'package:roomtime/presentation/features/room/widgets/room_title.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/glass_text_field.dart';
import 'package:roomtime/presentation/widgets/invite_panel.dart';
import 'package:roomtime/presentation/widgets/liquid_bounce_button.dart';

typedef DeviceChoice = ({bool camera, bool microphone});

class LobbyView extends StatelessWidget {
  final RoomCode code;
  final VoidCallback onHome;
  final ValueChanged<DeviceChoice> onJoining;

  const LobbyView({
    super.key,
    required this.code,
    required this.onHome,
    required this.onJoining,
  });

  @override
  Widget build(BuildContext context) {
    final lobby = context.read<LobbyCubit>();
    return BlocBuilder<LobbyCubit, LobbyState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return switch (state.status) {
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
        };
      },
    );
  }
}

class _LobbyForm extends StatefulWidget {
  final RoomCode code;
  final VoidCallback onHome;
  final ValueChanged<DeviceChoice> onJoining;

  const _LobbyForm({
    required this.code,
    required this.onHome,
    required this.onJoining,
  });

  @override
  State<_LobbyForm> createState() {
    return _LobbyFormState();
  }
}

class _LobbyFormState extends State<_LobbyForm> {
  static const _defaultLockout = Duration(seconds: 60);
  static const double _backButtonBand = 72;

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

  String? _lockoutAnnouncement;
  Timer? _lockoutTimer;
  bool _announceRetry = false;

  bool _joining = false;

  late final bool _autofocusName = !isTouchPlatform && _name.text.isEmpty;

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (!_isJoining) {
          unawaited(_lobby.refreshAccess());
        }
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

  void _rebuild() {
    setState(() {});
  }

  bool get _isJoining {
    return _joining || _room.state is RoomConnecting;
  }

  bool get _canJoin {
    return !_isJoining &&
        _lockoutSeconds == 0 &&
        GuestProfile.normalizeDisplayName(_name.text) != null &&
        (!_needsPassword || _password.text.isNotEmpty);
  }

  Future<void> _join() async {
    final name = GuestProfile.normalizeDisplayName(_name.text);
    if (name == null) {
      setState(() {
        _nameError = _name.text.trim().isEmpty
            ? context.l10n.roomNameRequired
            : context.l10n.roomNameTooLong;
      });
      return;
    }
    if (!_canJoin) {
      return;
    }
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
    await _lobby.releaseDevices();
    if (!mounted) {
      return;
    }
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
    if (state is! RoomFailed || isFullScreenJoinFailure(state.failure)) {
      return;
    }
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
      if (mounted) {
        _passwordFocus.requestFocus();
      }
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
      if (!mounted) {
        timer.cancel();
        return;
      }
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
    final title = roomTitle(context, summary.name, summary.code);
    final preview = state.preview;
    final joining = _isJoining;
    void toggleMicrophone() {
      if (!_isJoining) {
        _lobby.setMicrophoneEnabled(!preview.microphoneEnabled);
      }
    }

    void toggleCamera() {
      if (!_isJoining) {
        _lobby.setCameraEnabled(!preview.cameraEnabled);
      }
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
            LobbyBackdrop(preview: preview, name: name),
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
        LobbyDeviceNotices(
          preview: preview,
          joining: joining,
          canOpenSettings: _lobby.canOpenSettings,
          onRequestAccess: _lobby.requestAccess,
          onOpenSettings: _lobby.openSettings,
        ),
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
            if (_nameError != null) {
              setState(() => _nameError = null);
            }
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
          // Omit autofillHints so password managers don't save room passwords per web origin.
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
