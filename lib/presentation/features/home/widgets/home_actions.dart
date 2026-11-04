import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../theme/theme.dart';
import '../../../utils/failure_message.dart';
import '../../../widgets/widgets.dart';
import '../bloc/home_bloc.dart';
import 'create_room_dialog.dart';

/// The solid #00AEFF "Create Room" CTA of dev-0.1.6: radius 16 and 17 w600
/// on phones, radius 12 and 16 w600 in the sidebar.
class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({super.key, this.sidebar = false});

  final bool sidebar;

  @override
  Widget build(BuildContext context) {
    final radius = sidebar ? 12.0 : 16.0;
    final label = context.l10n.homeCreateRoom;
    return CustomBounceButton(
      borderRadius: radius,
      semanticLabel: label,
      onPressed: () => showCreateRoomDialog(context),
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: sidebar ? 16 : 18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_call, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sidebar ? 16 : 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section label of the 0.1.6 sidebar ("Rooms"): 13 w600, white @ 0.9.
class HomeSectionLabel extends StatelessWidget {
  const HomeSectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Semantics(
          header: true,
          child: Text(
            text,
            // White @ 0.9: >= 4.5:1 over the veil on a bright frame (A11Y-02).
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      ?trailing,
    ],
  );
}

/// Code-or-link field ([CustomTextField]) with Join (flows.md §1). Enter
/// or the keyboard Go action joins; the input is checked with `RoomCode` in
/// the bloc before any request, and an error under the field (red, human
/// message, never the exception) brings the focus back to it.
class JoinWithCodeField extends StatefulWidget {
  const JoinWithCodeField({super.key});

  @override
  State<JoinWithCodeField> createState() => _JoinWithCodeFieldState();
}

class _JoinWithCodeFieldState extends State<JoinWithCodeField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final HomeBloc _bloc = context.read<HomeBloc>();
  String _lastText = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_controller.text == _lastText) return;
    _lastText = _controller.text;
    _bloc.add(const HomeJoinInputChanged());
    setState(() {});
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    _bloc.add(HomeJoinSubmitted(_controller.text));
  }

  static String? _errorText(AppLocalizations l10n, HomeState state) {
    final inputError = state.joinError;
    if (inputError != null) {
      return switch (inputError) {
        JoinInputError.invalidCode => l10n.homeInvalidCode,
        JoinInputError.notARoomLink => l10n.homeNotARoomLink,
      };
    }
    return state.joinFailure?.localizedMessage(l10n);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          _errorText(context.l10n, current) != null &&
          (previous.joinError != current.joinError ||
              previous.joinFailure != current.joinFailure),
      // Focus returns to the field so the user can correct it.
      listener: (context, state) => _focusNode.requestFocus(),
      buildWhen: (previous, current) =>
          previous.isLookingUp != current.isLookingUp ||
          previous.joinError != current.joinError ||
          previous.joinFailure != current.joinFailure,
      builder: (context, state) {
        final hasText = _controller.text.trim().isNotEmpty;
        final error = _errorText(context.l10n, state);
        final label = state.isLookingUp
            ? context.l10n.homeChecking
            : context.l10n.homeJoin;
        final button = Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: state.isLookingUp
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintText: context.l10n.homeJoinLabel,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 12),
                if (hasText && !state.isLookingUp)
                  CustomBounceButton(
                    borderRadius: 16,
                    semanticLabel: label,
                    onPressed: _submit,
                    child: ExcludeSemantics(child: button),
                  )
                else
                  Semantics(
                    button: true,
                    enabled: false,
                    label: label,
                    excludeSemantics: true,
                    child: Opacity(opacity: 0.5, child: button),
                  ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              // Over the camera veil: on a plate (A11Y-01).
              GlassErrorText(error, plated: true),
            ],
          ],
        );
      },
    );
  }
}
