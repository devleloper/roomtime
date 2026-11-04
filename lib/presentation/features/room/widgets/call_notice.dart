import 'dart:async';

import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';

/// Top-centered pill for "Anna joined" / "Anna left" (flows.md §5): shown for
/// 3 s as a polite live region. [CallNoticeController.show] replaces the text.
class CallNoticeController extends ChangeNotifier {
  String? _message;
  Timer? _timer;

  String? get message => _message;

  void show(String message, {Duration duration = const Duration(seconds: 3)}) {
    _message = message;
    _timer?.cancel();
    _timer = Timer(duration, () {
      _message = null;
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// The 0.1.6 folding HUD pill: glass (blur 12, white @ 0.1 rim) with
/// `info_outline` and the message, sliding in from below. The tint is
/// black @ 0.7 (0.1.6: 0.5) so the text keeps 4.5:1 over a bright frame;
/// with reduced motion it appears without the slide.
/// Black tint of the call HUD glass over live video (pill and notices).
const double callHudTintAlpha = 0.7;

class CallNotice extends StatelessWidget {
  const CallNotice({super.key, required this.controller});

  final CallNoticeController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final message = controller.message;
        final reduced = AppMotion.reduced(context);
        return IgnorePointer(
          child: AnimatedSwitcher(
            duration: AppMotion.resolve(context, AppMotion.medium),
            transitionBuilder: (child, animation) => reduced
                ? FadeTransition(opacity: animation, child: child)
                : FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                      child: child,
                    ),
                  ),
            child: message == null
                ? const SizedBox.shrink()
                : Semantics(
                    key: ValueKey(message),
                    liveRegion: true,
                    child: LiquidGlassContainer(
                      blur: 12,
                      borderRadius: 100,
                      backgroundColor: Colors.black.withValues(
                        alpha: callHudTintAlpha,
                      ),
                      borderColor: Colors.white.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
