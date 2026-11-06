import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomtime/core/router/app_routes.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/home/bloc/home_bloc.dart';
import 'package:roomtime/presentation/features/home/widgets/camera_background_view.dart';
import 'package:roomtime/presentation/features/home/widgets/create_room_dialog.dart';
import 'package:roomtime/presentation/features/home/widgets/home_actions.dart';
import 'package:roomtime/presentation/features/home/widgets/home_desktop_layout.dart';
import 'package:roomtime/presentation/features/home/widgets/home_mobile_layout.dart';

class HomeScreen extends StatefulWidget {
  final bool openCreateSheet;

  final PendingHomeNotice? notices;

  final MediaPreview Function()? createPreview;

  const HomeScreen({
    super.key,
    this.openCreateSheet = false,
    this.notices,
    this.createPreview,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MediaPreview? _preview;
  StreamSubscription<MediaPreviewState>? _previewSubscription;
  late final AppLifecycleListener _lifecycle;
  MediaPreviewState _camera = const MediaPreviewState();

  ScaffoldMessengerState? _messenger;

  bool _wantCamera = false;
  bool _routeVisible = true;
  bool _appVisible = true;
  bool _running = false;

  HomeCameraToggle? get _cameraToggle {
    final isDeniedAndOff =
        !_wantCamera && _camera.cameraAccess == DeviceAccess.denied;
    if (_preview == null || isDeniedAndOff) {
      return null;
    }
    return (on: _wantCamera, onPressed: _toggleCamera);
  }

  @override
  void initState() {
    super.initState();
    final preview = widget.createPreview?.call();
    _preview = preview;
    _previewSubscription = preview?.states.listen((state) {
      if (mounted) {
        setState(() {
          _camera = state;
        });
      }
    });
    _lifecycle = AppLifecycleListener(onStateChange: _onLifecycle);
    unawaited(_probeAccess());
    if (widget.openCreateSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCreateRoomDialog(context);
        }
      });
    }
    widget.notices?.addListener(_showNotice);
    _showNotice();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notices == oldWidget.notices) {
      return;
    }
    oldWidget.notices?.removeListener(_showNotice);
    widget.notices?.addListener(_showNotice);
    _showNotice();
  }

  void _showNotice() {
    final notice = widget.notices?.take();
    if (notice == null) {
      return;
    }
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
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
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible != _routeVisible) {
      _routeVisible = visible;
      unawaited(_syncCamera());
    }
  }

  @override
  void dispose() {
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
    if (visible == _appVisible) {
      return;
    }
    _appVisible = visible;
    unawaited(_syncCamera());
  }

  Future<void> _probeAccess() async {
    final preview = _preview;
    if (preview == null) {
      return;
    }
    await preview.start(camera: false, microphone: false);
    if (!mounted) {
      return;
    }
    if (preview.state.cameraAccess == DeviceAccess.granted) {
      _wantCamera = true;
      await _syncCamera();
    }
  }

  Future<void> _toggleCamera() async {
    final preview = _preview;
    if (preview == null) {
      return;
    }
    if (_wantCamera) {
      setState(() {
        _wantCamera = false;
      });
      await _syncCamera();
      return;
    }
    if (preview.state.cameraAccess == DeviceAccess.notAsked) {
      await preview.requestAccess();
      if (!mounted) {
        return;
      }
      if (preview.state.cameraAccess == DeviceAccess.denied) {
        return;
      }
    }
    setState(() {
      _wantCamera = true;
    });
    await _syncCamera();
  }

  Future<void> _syncCamera() async {
    final preview = _preview;
    if (preview == null) {
      return;
    }
    final run = _wantCamera && _routeVisible && _appVisible;
    if (run == _running) {
      return;
    }
    _running = run;
    if (run) {
      await preview.start(camera: true, microphone: false);
    } else {
      await preview.release();
    }
    if (mounted) {
      setState(() {});
    }
  }

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
