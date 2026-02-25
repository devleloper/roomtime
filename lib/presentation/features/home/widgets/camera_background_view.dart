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
    // Delay initialization to avoid blocking the route transition animation
    // and to ensure any previous Room instance has finished disconnecting
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _initCamera();
    });
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
    final track = _videoTrack;
    if (track != null) {
      // Stop and dispose immediately to release hardware locks for the next screen
      track.stop();
      track.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _videoTrack == null
          ? Container(key: const ValueKey('placeholder'), color: Colors.black)
          : Stack(
              key: const ValueKey('camera'),
              fit: StackFit.expand,
              children: [
                VideoTrackRenderer(_videoTrack!, fit: VideoViewFit.cover),
              ],
            ),
    );
  }
}
