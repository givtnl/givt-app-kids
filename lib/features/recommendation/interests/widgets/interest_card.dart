import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    required this.interest,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final Tag interest;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionTile(
          isDisabled: false,
          titleSmall: interest.displayText,
          iconPath: interest.pictureUrl,
          onTap: onPressed,
          isSelected: isSelected,
          borderColor: interest.area.accentColor,
          backgroundColor: interest.area.backgroundColor,
          textColor: interest.area.textColor,
        ),
      ],
    );
  }
}
