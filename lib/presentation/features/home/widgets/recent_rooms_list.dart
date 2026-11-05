import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../domain/entities/recent_room.dart';
import '../../../../domain/entities/room.dart';
import '../../../../l10n/l10n.dart';
import '../../../invite/invite_sharing.dart';
import '../../../widgets/widgets.dart';
import '../bloc/home_bloc.dart';

/// Rooms this device created or joined, newest first, as the plain rows of
/// the dev-0.1.6 room list (name 17 w600, a videocam caption, 1 px
/// dividers). A row rejoins through the lobby; the trailing button forgets
/// it locally and offers Undo.
class RecentRoomsList extends StatelessWidget {
  const RecentRoomsList({
    super.key,
    this.dividerColor = Colors.white24,
    this.emptyFontSize = 16,
    this.now = DateTime.now,
  });

  final Color dividerColor;
  final double emptyFontSize;
  final DateTime Function() now;

  static String relativeTime(
    AppLocalizations l10n,
    DateTime then,
    DateTime now,
  ) {
    final age = now.difference(then);
    if (age.inMinutes < 1) return l10n.homeJustNow;
    if (age.inHours < 1) return l10n.homeMinutesAgo(age.inMinutes);
    if (age.inDays < 1) return l10n.homeHoursAgo(age.inHours);
    if (age.inDays == 1) return l10n.homeYesterday;
    return l10n.homeDaysAgo(age.inDays);
  }

  /// Removes at once and offers Undo.
  static void _remove(BuildContext context, HomeBloc bloc, RecentRoom room) {
    bloc.add(HomeRecentRoomRemoved(room.code));
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.homeRecentRemoved),
          action: SnackBarAction(
            label: context.l10n.homeUndo,
            onPressed: () {
              if (!bloc.isClosed) bloc.add(HomeRecentRoomRestored(room));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.recentRooms != current.recentRooms ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        final rooms = state.recentRooms;
        if (rooms.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              context.l10n.homeRecentEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: emptyFontSize,
              ),
            ),
          );
        }
        final current = now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < rooms.length; i++) ...[
              if (i > 0) Divider(color: dividerColor, height: 1),
              _RecentRoomTile(
                key: ValueKey(rooms[i].code.value),
                room: rooms[i],
                when: relativeTime(context.l10n, rooms[i].lastJoined, current),
                onOpen: () => context.go(AppRoutes.room(rooms[i].code)),
                onRemove: () => _remove(context, bloc, rooms[i]),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RecentRoomTile extends StatelessWidget {
  const _RecentRoomTile({
    super.key,
    required this.room,
    required this.when,
    required this.onOpen,
    required this.onRemove,
  });

  final RecentRoom room;
  final String when;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final name = room.name;
    final hasName = name != null && name.isNotEmpty;
    final title = hasName ? name : room.code.display;
    String caption(String code) => [
      if (hasName) code,
      when,
      if (room.role == RoomRole.host) context.l10n.homeRecentHost,
    ].join(' · ');
    // A bare code is spelled out, like on the invite card.
    final spokenCode = spokenRoomCode(room.code.display);
    // 0.1.6 had white @ 0.5; over the veil on a bright frame that is about
    // 2:1. White @ 0.85 on the black @ 0.6 veil keeps 4.5:1.
    final secondary = Colors.white.withValues(alpha: 0.85);
    final largeText = MediaQuery.textScalerOf(context).scale(14) > 18;
    return Row(
      children: [
        Expanded(
          child: CustomBounceButton(
            borderRadius: 16,
            overlayOpacity: 0,
            scaleFactor: 1.02,
            onPressed: onOpen,
            semanticLabel: context.l10n.homeRecentRow(
              hasName ? title : spokenCode,
              caption(spokenCode),
            ),
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.videocam, color: secondary, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            caption(room.code.display),
                            maxLines: largeText ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: secondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: context.l10n.homeRecentRemoveFor(title),
          icon: Icon(Icons.close, color: secondary, size: 20),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
