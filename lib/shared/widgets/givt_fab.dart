import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/givt_button_wrapper.dart';

class GivtFloatingActionButton extends StatelessWidget {
  const GivtFloatingActionButton({
    super.key,
    this.isDisabled,
    required this.onTap,
    required this.text,
    this.leftIcon,
    this.rightIcon,
  });

  final VoidCallback onTap;
  final bool? isDisabled;
  final String text;

  final Widget? leftIcon;
  final Widget? rightIcon;
  @override
  Widget build(BuildContext context) {
    return GivtButtonWrapper(
        onTap: onTap,
        isDisabled: isDisabled,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: getChild(context),
        ));
  }

  Widget getChild(BuildContext context) {
    if (leftIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.only(right: 8), child: leftIcon),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );
    }
    if (rightIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(padding: const EdgeInsets.only(left: 8), child: rightIcon),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
