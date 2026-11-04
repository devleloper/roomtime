import 'package:flutter/material.dart';

import '../../../../domain/failures/failure.dart';
import '../../../utils/failure_message.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../../l10n/l10n.dart';

/// Whether [failure] blocks the lobby and gets a full screen (flows.md §10);
/// the others show inline on the lobby form.
bool isFullScreenJoinFailure(Failure failure) => switch (failure) {
  RoomNotFoundFailure() ||
  InvalidCodeFailure() ||
  RoomFullFailure() ||
  RoomLockedFailure() ||
  ParticipantBannedFailure() => true,
  _ => false,
};

/// Full-screen join or lookup error. Invalid, expired, ended and revoked
/// codes share one "Room not found" message on purpose (ADR-0003).
class JoinErrorView extends StatelessWidget {
  const JoinErrorView({
    super.key,
    required this.failure,
    required this.onHome,
    this.onRetry,
    this.maxParticipants,
  });

  final Failure failure;
  final VoidCallback onHome;

  /// "Try again" (full, locked, network); null hides it.
  final VoidCallback? onRetry;
  final int? maxParticipants;

  @override
  Widget build(BuildContext context) {
    // Not found and banned have no retry.
    final onRetry =
        failure is RoomNotFoundFailure ||
            failure is InvalidCodeFailure ||
            failure is ParticipantBannedFailure
        ? null
        : this.onRetry;
    final home = GlassDialogButton(
      label: context.l10n.roomHome,
      onPressed: onHome,
      style: onRetry == null
          ? GlassButtonStyle.primary
          : GlassButtonStyle.secondary,
      autofocus: onRetry == null,
    );
    final retry = onRetry == null
        ? null
        : GlassDialogButton(
            label: context.l10n.roomTryAgain,
            onPressed: onRetry,
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
