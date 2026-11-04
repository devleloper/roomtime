import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/widgets.dart';

/// The original dev-0.1.6 widgets over a camera-like gradient: Home (veil,
/// refresh circle, Create Room CTA, room rows), Call (room pill, glass
/// controls), Create dialog, and the remaining pieces (CustomCard,
/// CustomTextField, themed Material buttons and fields, sidebar circle).
///
/// Always a smoke test. With `ORIGINAL_PREVIEW_OUT=<path>.png` it writes
/// the image for docs/design (no golden files):
///
///     ORIGINAL_PREVIEW_OUT=../docs/design/img/original-widgets.png \
///       flutter test test/presentation/widgets/original_widgets_preview_test.dart
void main() {
  testWidgets('original widgets preview', (tester) async {
    final out = Platform.environment['ORIGINAL_PREVIEW_OUT'];
    if (out != null) {
      await tester.runAsync(_loadFonts);
    }
    tester.view.physicalSize = const Size(1656, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: RepaintBoundary(
          key: key,
          child: Material(
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  for (final (i, screen) in [
                    _home(),
                    _call(),
                    _dialog(),
                    _kit(),
                  ].indexed) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.lg),
                    _Phone(child: screen),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // The banner spinner never settles; a second is enough for every entry.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);

    if (out != null) {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(out).writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }
  });
}

Future<void> _loadFonts() async {
  Future<ByteData> bytes(String path) async =>
      ByteData.sublistView(File(path).readAsBytesSync());
  // Native text uses the platform family (Roboto in tests, VIS-01); no
  // Roboto file ships, so Inter stands in for it in the preview.
  for (final family in ['Inter', 'Roboto']) {
    await (FontLoader(
      family,
    )..addFont(bytes('assets/fonts/inter/InterVariable.ttf'))).load();
  }
  final root = Platform.environment['FLUTTER_ROOT'];
  final icons =
      '$root/bin/cache/artifacts/material_fonts/'
      'MaterialIcons-Regular.otf';
  if (root != null && File(icons).existsSync()) {
    await (FontLoader('MaterialIcons')..addFont(bytes(icons))).load();
  }
}

const _white = AppColors.textPrimary;
Color _alpha(Color c, double a) => c.withValues(alpha: a);

class _Phone extends StatelessWidget {
  const _Phone({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.xlAll,
      child: SizedBox(width: 390, height: 812, child: child),
    );
  }
}

/// Stand-in for the front camera: saturated gradient, soft blobs, a bright
/// window (worst case for white text on glass).
class _Camera extends StatelessWidget {
  const _Camera();

  @override
  Widget build(BuildContext context) =>
      const SizedBox.expand(child: CustomPaint(painter: _CameraPainter()));
}

class _CameraPainter extends CustomPainter {
  const _CameraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A7BD5), Color(0xFFF7797D), Color(0xFFFBD786)],
        ).createShader(rect),
    );
    void blob(double x, double y, double r, Color color) {
      final c = Offset(size.width * x, size.height * y);
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    blob(0.25, 0.3, 160, const Color(0xFF2E7D32));
    blob(0.8, 0.55, 200, const Color(0xFF6A1B9A));
    blob(0.5, 0.85, 180, const Color(0xFFFFE082));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.12, 140, 180),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool shouldRepaint(_CameraPainter oldDelegate) => false;
}

Widget _veil({Widget? child}) => LiquidGlassContainer(
  blur: 30,
  backgroundColor: _alpha(Colors.black, AppGlass.veilTintAlpha),
  borderColor: Colors.transparent,
  borderRadius: 0,
  child: SizedBox.expand(child: child),
);

Widget _cta(String label, {double radius = 16, IconData? icon}) =>
    CustomBounceButton(
      onPressed: () {},
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: _white),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: _white,
              ),
            ),
          ],
        ),
      ),
    );

Widget _home() {
  return Stack(
    children: [
      const _Camera(),
      _veil(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'RoomTime',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: _white,
                      ),
                    ),
                  ),
                  LiquidBounceButton(
                    onPressed: () {},
                    icon: Icons.refresh,
                    bgColor: _alpha(AppColors.surface, 0.4),
                    size: 48,
                    iconSize: 24,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _cta('Create Room', icon: Icons.video_call),
              const SizedBox(height: 32),
              for (final name in ['Family Room', 'Grandma', 'Book club']) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: _white,
                        ),
                      ),
                      Text(
                        'RoomTime Video',
                        style: TextStyle(
                          fontSize: 14,
                          color: _alpha(_white, 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _call() {
  final off = _alpha(AppColors.error, 0.4);
  final on = _alpha(AppColors.surface, 0.4);
  return Stack(
    children: [
      const _Camera(),
      Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Center(
          child: LiquidGlassContainer(
            borderRadius: 100,
            backgroundColor: _alpha(Colors.black, 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: const Text(
              'Family Room',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: _white,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 120,
        left: 0,
        right: 0,
        child: Center(
          child: LiquidGlassContainer(
            borderRadius: 100,
            backgroundColor: _alpha(Colors.black, 0.5),
            borderColor: _alpha(_white, AppGlass.subtleBorderAlpha),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 20, color: _white),
                SizedBox(width: 8),
                Text(
                  'Anna joined',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 30,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (icon, tint) in [
              (Icons.mic_off, off),
              (Icons.videocam, on),
              (Icons.cameraswitch, on),
              (Icons.call_end, off),
            ]) ...[
              if (icon != Icons.mic_off) const SizedBox(width: 20),
              LiquidBounceButton(onPressed: () {}, icon: icon, bgColor: tint),
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _dialog() {
  return Stack(
    children: [
      _home(),
      ColoredBox(color: Colors.black54, child: const SizedBox.expand()),
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LiquidGlassContainer(
            blur: 30,
            backgroundColor: _alpha(
              AppColors.surface,
              AppGlass.dialogTintAlpha,
            ),
            borderColor: _alpha(_white, AppGlass.dialogBorderAlpha),
            borderRadius: 24,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Room',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _white,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: TextEditingController(text: 'Family Room'),
                  decoration: const InputDecoration(labelText: 'Room Name'),
                ),
                const SizedBox(height: 16),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password (Optional)'),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: _noop,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: FilledButton(
                        onPressed: _noop,
                        child: Text('Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _kit() {
  return ColoredBox(
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Rooms',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _alpha(_white, 0.7),
                ),
              ),
              const Spacer(),
              LiquidBounceButton(
                onPressed: () {},
                icon: Icons.refresh,
                bgColor: _alpha(_white, 0.1),
                size: 28,
                iconSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _white,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'Email',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: TextEditingController(text: 'secret'),
                  hintText: 'Password',
                  isPassword: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const FilledButton(onPressed: _noop, child: Text('Join call')),
          const SizedBox(height: 12),
          const OutlinedButton(onPressed: _noop, child: Text('Copy link')),
        ],
      ),
    ),
  );
}

void _noop() {}
