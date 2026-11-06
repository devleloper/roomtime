import 'package:flutter/material.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';

bool isFullScreenJoinFailure(Failure failure) {
  return switch (failure) {
    RoomNotFoundFailure() ||
    InvalidCodeFailure() ||
    RoomFullFailure() ||
    RoomLockedFailure() ||
    ParticipantBannedFailure() => true,
    _ => false,
  };
}

class JoinErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback onHome;

  final VoidCallback? onRetry;
  final int? maxParticipants;

  const JoinErrorView({
    super.key,
    required this.failure,
    required this.onHome,
    this.onRetry,
    this.maxParticipants,
  });

  @override
  Widget build(BuildContext context) {
    final canRetry =
        failure is! RoomNotFoundFailure &&
        failure is! InvalidCodeFailure &&
        failure is! ParticipantBannedFailure;
    final retryCallback = canRetry ? onRetry : null;
    final home = GlassDialogButton(
      label: context.l10n.roomHome,
      onPressed: onHome,
      style: retryCallback == null
          ? GlassButtonStyle.primary
          : GlassButtonStyle.secondary,
      autofocus: retryCallback == null,
    );
    final retry = retryCallback == null
        ? null
        : GlassDialogButton(
            label: context.l10n.roomTryAgain,
            onPressed: retryCallback,
            style: GlassButtonStyle.primary,
            autofocus: true,
          );
    final actions = [home, ?retry];
    final max = maxParticipants;
    final (icon, title, message) = switch (failure) {
      RoomNotFoundFailure() || InvalidCodeFailure() => (
        Icons.search_off,
        context.l10n.roomNotFoundTitle,
        context.l10n.roomNotFoundBody,
      ),
      RoomFullFailure() => (
        Icons.groups,
        context.l10n.roomFullTitle,
        max == null
            ? context.l10n.roomFullBodyUnknown
            : context.l10n.roomFullBody(max),
      ),
      RoomLockedFailure() => (
        Icons.lock_outline,
        context.l10n.roomLockedTitle,
        context.l10n.roomLockedBody,
      ),
      ParticipantBannedFailure() => (
        Icons.block,
        context.l10n.roomBannedTitle,
        context.l10n.roomBannedBody,
      ),
      _ => (
        Icons.cloud_off,
        failure is NetworkFailure
            ? context.l10n.roomNoConnectionTitle
            : context.l10n.roomSomethingWrongTitle,
        failure.localizedMessage(context.l10n),
      ),
    };
    return GlassStatusScreen(
      icon: icon,
      title: title,
      message: message,
      actions: actions,
    );
  }
}
