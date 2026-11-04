import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// macOS (also Safari/Chrome on a Mac) uses ⌘, everything else Ctrl.
bool get _useMeta => defaultTargetPlatform == TargetPlatform.macOS;

/// Shortcut text for tooltips and the help dialog: "Ctrl+D" or "⌘D".
String shortcutLabel(String key, {bool alt = false}) =>
    _useMeta ? '⌘${alt ? '⌥' : ''}$key' : 'Ctrl+${alt ? 'Alt+' : ''}$key';

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

/// Call shortcuts (flows.md §11) for the lobby and the call. They only use
/// modifier chords, and they are disabled while a text field has focus, so
/// Ctrl+D / Ctrl+E keep their editing meaning there. No shortcut leaves or
/// ends a call.
class MediaShortcuts extends StatelessWidget {
  const MediaShortcuts({
    super.key,
    required this.child,
    required this.onToggleMicrophone,
    required this.onToggleCamera,
    this.onToggleParticipants,
    this.onShowShortcuts,
    this.autofocus = true,
  });

  final Widget child;
  final VoidCallback onToggleMicrophone;
  final VoidCallback onToggleCamera;
  final VoidCallback? onToggleParticipants;
  final VoidCallback? onShowShortcuts;

  /// Takes focus when nothing else has it (the call screen). Off in the
  /// lobby, where the name field or Join gets initial focus.
  final bool autofocus;

  static SingleActivator _chord(LogicalKeyboardKey key, {bool alt = false}) =>
      SingleActivator(key, meta: _useMeta, control: !_useMeta, alt: alt);

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
        // Keeps the chords working when nothing inside has focus yet.
        child: Focus(autofocus: autofocus, skipTraversal: true, child: child),
      ),
    );
  }
}

class _OutsideTextFieldAction<T extends Intent> extends Action<T> {
  _OutsideTextFieldAction(this.onInvoke);

  final VoidCallback onInvoke;

  static bool get _focusInTextField {
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused == null) return false;
    return focused.widget is EditableText ||
        focused.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  // A disabled action lets the key event continue to the text field.
  @override
  bool isEnabled(T intent) => !_focusInTextField;

  @override
  Object? invoke(T intent) {
    onInvoke();
    return null;
  }
}
