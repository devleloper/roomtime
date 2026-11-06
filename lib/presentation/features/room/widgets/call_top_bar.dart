import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/widgets/dynamic_island_badge.dart';
import 'package:roomtime/presentation/features/room/widgets/media_controls.dart';
import 'package:roomtime/presentation/features/room/widgets/room_title.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class CallTopBar extends StatelessWidget {
  static const double topInset = 16;

  final RoomInCall state;
  final bool visible;
  final Duration fadeDuration;
  final VoidCallback onToggleParticipants;
  final VoidCallback onInvite;

  const CallTopBar({
    super.key,
    required this.state,
    required this.visible,
    required this.fadeDuration,
    required this.onToggleParticipants,
    required this.onInvite,
  });

  static bool _hasIsland(BuildContext context) {
    final media = MediaQuery.of(context);
    return !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        media.orientation == Orientation.portrait &&
        media.padding.top >= 59;
  }

  Widget _fade(Widget child) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: fadeDuration,
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeSemantics(excluding: !visible, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final people = state.call.participants.length;
    final title = roomTitle(context, state.room.name, state.room.code);
    final island = _hasIsland(context);
    final safeTop = MediaQuery.paddingOf(context).top;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Center(
            child: Semantics(
              header: true,
              child: DynamicIslandBadge(
                roomName: title,
                isVisible: visible,
                hasDynamicIsland: island,
                islandOffset: island
                    ? AppSizes.dynamicIslandTop - (safeTop + topInset)
                    : 0,
              ),
            ),
          ),
        ),
        Row(
          children: [
            _fade(
              MediaControlButton(
                icon: Icons.group,
                label:
                    '${context.l10n.roomParticipants}, '
                    '${context.l10n.roomParticipantCount(people)}',
                tooltip: context.l10n.roomParticipants,
                size: 48,
                onPressed: onToggleParticipants,
              ),
            ),
            const Spacer(),
            _fade(
              MediaControlButton(
                icon: Icons.person_add,
                label: context.l10n.roomInvite,
                size: 48,
                onPressed: onInvite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
