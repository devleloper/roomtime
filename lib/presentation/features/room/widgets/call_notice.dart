import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';

class CallNoticeController extends ChangeNotifier {
  String? _message;
  Timer? _timer;

  String? get message {
    return _message;
  }

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

class CallNotice extends StatelessWidget {
  final CallNoticeController controller;

  const CallNotice({super.key, required this.controller});

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
            transitionBuilder: (child, animation) {
              if (reduced) {
                return FadeTransition(opacity: animation, child: child);
              }
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                  child: child,
                ),
              );
            },
            child: message == null
                ? const SizedBox.shrink()
                : GlassHudPill(
                    key: ValueKey(message),
                    icon: Icons.info_outline,
                    message: message,
                  ),
          ),
        );
      },
    );
  }
}
