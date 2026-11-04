import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../domain/services/media_preview.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/home_bloc.dart';
import '../widgets/camera_background_view.dart';
import '../../../shared/platform.dart';
import '../widgets/create_room_dialog.dart';
import 'layouts/home_camera_toggle.dart';
import 'layouts/home_desktop_layout.dart';
import 'layouts/home_mobile_layout.dart';

/// Home in the dev-0.1.6 look (flows.md §1, §14): the live front camera
/// behind a frosted veil (phone) or beside the 380 dp glass sidebar
/// (tablet, desktop), title, Create Room, join with a code and the recent
/// rooms.
///
/// Camera rules (privacy, battery): [createPreview] is only started when
/// camera access is already granted; Home never shows a permission prompt
/// by itself (the round camera button does, on a tap). The camera stops
/// while another route covers Home or the app is in the background, and on
/// web or macOS (no permission query) it waits for the tap.
///
/// Expects a [HomeBloc] from the route.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.openCreateSheet = false,
    this.notices,
    this.createPreview,
  });

  /// Opens the Create Room dialog after the first frame.
  final bool openCreateSheet;

  /// One-shot notices (e.g. a malformed invite link), shown as a SnackBar
  /// on arrival and whenever one is posted while Home is up.
  final PendingHomeNotice? notices;

  /// Camera preview for the backdrop; null shows the black fallback.
  final MediaPreview Function()? createPreview;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MediaPreview? _preview;
  StreamSubscription<MediaPreviewState>? _previewSubscription;
  late final AppLifecycleListener _lifecycle;
  MediaPreviewState _camera = const MediaPreviewState();

  /// Kept to hide Home's Undo SnackBar when Home goes away (CR4-3).
  ScaffoldMessengerState? _messenger;

  /// Access is granted (or the user tapped the camera button).
  bool _wantCamera = false;
  bool _routeVisible = true;
  bool _appVisible = true;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    final preview = _preview = widget.createPreview?.call();
    _previewSubscription = preview?.states.listen((state) {
      if (mounted) setState(() => _camera = state);
    });
    _lifecycle = AppLifecycleListener(onStateChange: _onLifecycle);
    unawaited(_probeAccess());
    if (widget.openCreateSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showCreateRoomDialog(context);
      });
    }
    widget.notices?.addListener(_showNotice);
    _showNotice();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notices == oldWidget.notices) return;
    oldWidget.notices?.removeListener(_showNotice);
    widget.notices?.addListener(_showNotice);
    _showNotice();
  }

  void _showNotice() {
    final notice = widget.notices?.take();
    if (notice == null) return;
    // A redirect back to Home may not rebuild it: ask for the frame.
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final text = switch (notice) {
        HomeNotice.invalidInviteLink => context.l10n.homeInvalidInviteLink,
      };
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.maybeOf(context);
    // The navigator disables tickers of routes hidden behind an opaque
    // route (a pushed screen), not behind dialogs.
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible != _routeVisible) {
      _routeVisible = visible;
      unawaited(_syncCamera());
    }
  }

  @override
  void dispose() {
    // The root messenger outlives this route: its Undo must not reach the
    // closed HomeBloc (CR4-3).
    _messenger?.hideCurrentSnackBar();
    widget.notices?.removeListener(_showNotice);
    _lifecycle.dispose();
    unawaited(_previewSubscription?.cancel());
    unawaited(_preview?.dispose());
    super.dispose();
  }

  void _onLifecycle(AppLifecycleState state) {
    final visible =
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
    if (visible == _appVisible) return;
    _appVisible = visible;
    unawaited(_syncCamera());
  }

  /// Reads the permission state without prompting or opening a device.
  Future<void> _probeAccess() async {
    final preview = _preview;
    if (preview == null) return;
    await preview.start(camera: false, microphone: false);
    if (!mounted) return;
    if (preview.state.cameraAccess == DeviceAccess.granted) {
      _wantCamera = true;
      await _syncCamera();
    }
  }

  Future<void> _toggleCamera() async {
    final preview = _preview;
    if (preview == null) return;
    if (_wantCamera) {
      setState(() => _wantCamera = false);
      await _syncCamera();
      return;
    }
    if (preview.state.cameraAccess == DeviceAccess.notAsked) {
      await preview.requestAccess();
      if (!mounted) return;
      if (preview.state.cameraAccess == DeviceAccess.denied) return;
    }
    setState(() => _wantCamera = true);
    await _syncCamera();
  }

  Future<void> _syncCamera() async {
    final preview = _preview;
    if (preview == null) return;
    final run = _wantCamera && _routeVisible && _appVisible;
    if (run == _running) return;
    _running = run;
    if (run) {
      await preview.start(camera: true, microphone: false);
    } else {
      await preview.release();
    }
    if (mounted) setState(() {});
  }

  HomeCameraToggle? get _cameraToggle =>
      _preview == null ||
          (!_wantCamera && _camera.cameraAccess == DeviceAccess.denied)
      ? null
      : (on: _wantCamera, onPressed: _toggleCamera);

  @override
  Widget build(BuildContext context) {
    final track = _running && _camera.cameraEnabled ? _camera.videoTrack : null;
    final isPhone = isTouchPlatform;
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          current.joinTarget != null &&
          previous.joinTarget != current.joinTarget,
      listener: (context, state) {
        final target = state.joinTarget!;
        context.go(
          AppRoutes.room(target.code),
          extra: RoomRouteExtra(summary: target),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(child: CameraBackgroundView(videoTrack: track)),
            LayoutBuilder(
              builder: (context, constraints) {
                final isTabletOrDesktop = constraints.maxWidth > 600;
                if (isPhone && !isTabletOrDesktop) {
                  return HomeMobileLayout(camera: _cameraToggle);
                }
                return HomeDesktopLayout(camera: _cameraToggle);
              },
            ),
          ],
        ),
      ),
    );
  }
}
