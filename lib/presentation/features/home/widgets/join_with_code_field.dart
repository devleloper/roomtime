import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/home/bloc/home_bloc.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/custom_bounce_button.dart';
import 'package:roomtime/presentation/widgets/custom_text_field.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';

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
    if (_controller.text == _lastText) {
      return;
    }
    _lastText = _controller.text;
    _bloc.add(const HomeJoinInputChanged());
    setState(() {});
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) {
      return;
    }
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
              GlassErrorText(error, plated: true),
            ],
          ],
        );
      },
    );
  }
}
