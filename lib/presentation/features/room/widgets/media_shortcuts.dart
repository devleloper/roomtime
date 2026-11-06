import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool get _useMeta {
  return defaultTargetPlatform == TargetPlatform.macOS;
}

String shortcutLabel(String key, {bool alt = false}) {
  if (_useMeta) {
    final option = alt ? '⌥' : '';
    return '⌘$option$key';
  }
  final altPrefix = alt ? 'Alt+' : '';
  return 'Ctrl+$altPrefix$key';
}

final class ToggleMicrophoneIntent extends Intent {
  const ToggleMicrophoneIntent();
}

final class ToggleCameraIntent extends Intent {
  const ToggleCameraIntent();
}

final class ToggleParticipantsIntent extends Intent {
  const ToggleParticipantsIntent();
}

final class ShowShortcutsIntent extends Intent {
  const ShowShortcutsIntent();
}

class MediaShortcuts extends StatelessWidget {
  final Widget child;
  final VoidCallback onToggleMicrophone;
  final VoidCallback onToggleCamera;
  final VoidCallback? onToggleParticipants;
  final VoidCallback? onShowShortcuts;

  final bool autofocus;

  const MediaShortcuts({
    super.key,
    required this.child,
    required this.onToggleMicrophone,
    required this.onToggleCamera,
    this.onToggleParticipants,
    this.onShowShortcuts,
    this.autofocus = true,
  });

  static SingleActivator _chord(LogicalKeyboardKey key, {bool alt = false}) {
    return SingleActivator(key, meta: _useMeta, control: !_useMeta, alt: alt);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        _chord(LogicalKeyboardKey.keyD): const ToggleMicrophoneIntent(),
        _chord(LogicalKeyboardKey.keyE): const ToggleCameraIntent(),
        if (onToggleParticipants != null)
          _chord(LogicalKeyboardKey.keyP, alt: true):
              const ToggleParticipantsIntent(),
        if (onShowShortcuts != null)
          _chord(LogicalKeyboardKey.slash): const ShowShortcutsIntent(),
      },
      child: Actions(
        actions: {
          ToggleMicrophoneIntent:
              _OutsideTextFieldAction<ToggleMicrophoneIntent>(
                onToggleMicrophone,
              ),
          ToggleCameraIntent: _OutsideTextFieldAction<ToggleCameraIntent>(
            onToggleCamera,
          ),
          if (onToggleParticipants case final toggle?)
            ToggleParticipantsIntent:
                _OutsideTextFieldAction<ToggleParticipantsIntent>(toggle),
          if (onShowShortcuts case final show?)
            ShowShortcutsIntent: _OutsideTextFieldAction<ShowShortcutsIntent>(
              show,
            ),
        },
        child: Focus(autofocus: autofocus, skipTraversal: true, child: child),
      ),
    );
  }
}

class _OutsideTextFieldAction<T extends Intent> extends Action<T> {
  final VoidCallback onInvoke;

  _OutsideTextFieldAction(this.onInvoke);

  static bool get _focusInTextField {
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused == null) {
      return false;
    }
    return focused.widget is EditableText ||
        focused.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  @override
  bool isEnabled(T intent) {
    return !_focusInTextField;
  }

  @override
  Object? invoke(T intent) {
    onInvoke();
    return null;
  }
}
