import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/home/widgets/create_room_dialog.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/custom_bounce_button.dart';

typedef HomeCameraToggle = ({bool on, VoidCallback onPressed});

class CreateRoomButton extends StatelessWidget {
  final bool sidebar;

  const CreateRoomButton({super.key, this.sidebar = false});

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

class HomeSectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const HomeSectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              text,
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
}
