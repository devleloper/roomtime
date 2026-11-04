import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../domain/entities/room.dart';
import '../../../../l10n/l10n.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../theme/theme.dart';
import '../../../invite/invite_panel.dart';
import '../../../utils/failure_message.dart';
import '../bloc/home_bloc.dart';

/// Opens the dev-0.1.6 Create Room dialog (Room Name, Password (Optional),
/// Cancel / Create). After the room is created the same dialog shows the
/// invite step (copy link, copy code, share, Join) (flows.md §2, §3).
Future<void> showCreateRoomDialog(BuildContext context) {
  final bloc = context.read<HomeBloc>()..add(const HomeCreateFormOpened());
  return showGlassDialog<void>(
    context: context,
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const CreateRoomDialog()),
  );
}

class CreateRoomDialog extends StatelessWidget {
  const CreateRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.createdRoom != current.createdRoom,
      builder: (context, state) {
        final created = state.createdRoom;
        return AnimatedSize(
          duration: AppMotion.resolve(context, AppMotion.medium),
          curve: Curves.easeOutCubic,
          child: created == null
              ? const _CreateForm()
              : _InviteStep(room: created),
        );
      },
    );
  }
}

class _CreateForm extends StatefulWidget {
  const _CreateForm();

  @override
  State<_CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<_CreateForm> {
  final _name = TextEditingController();
  final _password = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Empty means no password; otherwise [RoomPassword], taken verbatim.
  String? _validatePassword(AppLocalizations l10n, String value) {
    if (value.isEmpty) return null;
    return switch (RoomPassword.check(value)) {
      RoomPasswordIssue.tooShort => l10n.homeCreatePasswordTooShort,
      RoomPasswordIssue.tooLong => l10n.homeCreatePasswordTooLong,
      null => null,
    };
  }

  void _submit() {
    final error = _validatePassword(context.l10n, _password.text);
    setState(() => _passwordError = error);
    if (error != null) return;
    final name = _name.text.trim();
    context.read<HomeBloc>().add(
      HomeCreateRoomRequested(
        CreateRoomParams(
          name: name.isEmpty ? null : name,
          // Limits are not asked (0.1.6): the server applies its defaults.
          password: _password.text.isEmpty ? null : _password.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;
    final failure = state.createFailure;
    final busy = state.isCreating;
    return GlassDialogContent(
      title: context.l10n.homeCreateRoom,
      body: [
        GlassTextField(
          controller: _name,
          label: context.l10n.homeCreateNameLabel,
          maxLength: 40,
          enabled: !busy,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        GlassTextField(
          controller: _password,
          label: context.l10n.homePasswordOptional,
          obscure: true,
          maxLength: RoomPassword.maxLength,
          enabled: !busy,
          errorText: _passwordError,
          autofillHints: const [AutofillHints.newPassword],
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_passwordError != null) setState(() => _passwordError = null);
          },
          onSubmitted: (_) => _submit(),
        ),
        if (failure != null) ...[
          const SizedBox(height: 16),
          GlassErrorText(
            failure.localizedMessage(context.l10n),
            textAlign: TextAlign.center,
          ),
        ],
      ],
      actions: [
        GlassDialogButton(
          label: context.l10n.homeCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        GlassDialogButton(
          label: failure != null
              ? context.l10n.homeCreateRetry
              : context.l10n.homeCreate,
          style: GlassButtonStyle.primary,
          isLoading: busy,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class _InviteStep extends StatelessWidget {
  const _InviteStep({required this.room});

  final CreatedRoom room;

  void _join(BuildContext context) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(AppRoutes.room(room.code));
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialogContent(
      title: context.l10n.inviteReady,
      body: [
        InvitePanel(
          code: room.code,
          inviteUrl: room.inviteUrl,
          roomName: room.name,
          passwordProtected: room.passwordRequired,
        ),
      ],
      actions: [
        GlassDialogButton(
          label: context.l10n.inviteDone,
          onPressed: () => Navigator.of(context).pop(),
        ),
        GlassDialogButton(
          label: context.l10n.homeJoin,
          style: GlassButtonStyle.primary,
          autofocus: true,
          onPressed: () => _join(context),
        ),
      ],
    );
  }
}
