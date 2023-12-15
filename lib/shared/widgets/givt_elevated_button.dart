import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/givt_button_wrapper.dart';

class GivtElevatedButton extends StatelessWidget {
  const GivtElevatedButton({
    super.key,
    this.isDisabled,
    required this.onTap,
    required this.text,
    this.isLoading,
    this.isSecondary,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
  });

  final VoidCallback? onTap;
  final bool? isDisabled;
  final bool? isSecondary;
  final String text;
  final bool? isLoading;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? leadingImage;

  @override
  Widget build(BuildContext context) {
    return GivtButtonWrapper(
      onTap: onTap,
      isDisabled: isDisabled,
      child: Container(
          width: MediaQuery.sizeOf(context).width * .9,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDisabled == true
                ? Theme.of(context).colorScheme.surfaceVariant
                : isSecondary == true
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.primaryContainer,
          ),
          child: getChild(context)),
    );
  }

  Widget getChild(BuildContext context) {
    if (isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }
    if (leftIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.only(right: 8), child: leftIcon),
          Text(
            text,
            style: isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      );
    }
    if (rightIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
          Padding(padding: const EdgeInsets.only(left: 8), child: leftIcon),
        ],
      );
    }
    if (leadingImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingImage!,
            Text(
              text,
              style: isDisabled == true
                  ? Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.outline)
                  : Theme.of(context).textTheme.labelMedium,
            ),
            // all leading images must be 32 pixels wide
            // this centers the text
            const SizedBox(width: 32),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        text,
        style: isDisabled == true
            ? Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline)
            : Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
