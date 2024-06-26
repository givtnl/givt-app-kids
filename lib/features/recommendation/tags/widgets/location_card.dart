import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  final Tag location;
  final void Function()? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ActionTile(
      isDisabled: false,
      titleSmall: location.displayText,
      iconPath: location.pictureUrl,
      onTap: onPressed ?? () {},
      isSelected: isSelected,
      borderColor: location.area.borderColor,
      backgroundColor: location.area.backgroundColor,
      textColor: location.area.textColor,
    );
  }
}
