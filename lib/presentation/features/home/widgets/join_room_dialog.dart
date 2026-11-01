import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bounce_button.dart';
import '../../../widgets/liquid_glass_container.dart';

class JoinRoomDialog extends StatefulWidget {
  final String? initialRoomName;
  final bool isCreating;

  const JoinRoomDialog({
    super.key,
    this.initialRoomName,
    this.isCreating = false,
  });

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  late TextEditingController _roomNameController;
  late TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController(text: widget.initialRoomName);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final roomName = _roomNameController.text.trim();
    if (roomName.isEmpty) {
      setState(() => _errorText = 'Room name cannot be empty');
      return;
    }
    
    final RegExp roomNameRegex = RegExp(r'^[a-zA-Z0-9\-_ ]+$');
    if (!roomNameRegex.hasMatch(roomName)) {
      setState(() => _errorText = 'Use only letters, numbers, spaces, - or _');
      return;
    }

    final pin = _passwordController.text.trim();
    
    // Pass parameters via query parameters since go_router state.extra can be tricky with deep links
    final uri = Uri(
      path: '/room/$roomName',
      queryParameters: {
        if (pin.isNotEmpty) 'pin': pin,
      },
    );

    context.pop(); // Close dialog
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiquidGlassContainer(
        blur: 30,
        backgroundColor: AppColors.surface.withValues(alpha: 0.5),
        borderColor: Colors.white.withValues(alpha: 0.2),
        borderRadius: 24,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isCreating ? 'Create Room' : 'Join Room',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _roomNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Room Name',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  errorText: _errorText,
                  errorStyle: const TextStyle(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password (Optional)',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomBounceButton(
                      onPressed: () => context.pop(),
                      borderRadius: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomBounceButton(
                      onPressed: _submit,
                      borderRadius: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.isCreating ? 'Create' : 'Join',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
