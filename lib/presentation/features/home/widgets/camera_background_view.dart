import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class CameraBackgroundView extends StatefulWidget {
  const CameraBackgroundView({super.key});

  @override
  State<CameraBackgroundView> createState() => _CameraBackgroundViewState();
}

class _CameraBackgroundViewState extends State<CameraBackgroundView> {
  LocalVideoTrack? _videoTrack;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final track = await LocalVideoTrack.createCameraTrack(
        const CameraCaptureOptions(cameraPosition: CameraPosition.front),
      );
      if (mounted) {
        setState(() {
          _videoTrack = track;
        });
      }
    } catch (e) {
      debugPrint('Failed to init camera for background: $e');
    }
  }

  @override
  void dispose() {
    _videoTrack?.stop();
    _videoTrack?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoTrack == null) {
      return Container(color: Colors.black);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        VideoTrackRenderer(_videoTrack!, fit: VideoViewFit.cover),
        // Glassmorphism heavy blur and darkening overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.black.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
