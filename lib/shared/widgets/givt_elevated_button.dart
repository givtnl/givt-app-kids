import 'package:flutter/material.dart';

class GivtElevatedButton extends StatefulWidget {
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
  _GivtElevatedButtonState createState() => _GivtElevatedButtonState();
}

class _GivtElevatedButtonState extends State<GivtElevatedButton> {
  double dropShadowHeight = 4;
  double paddingtop = 4;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDisabled == true || isPressed == true) {
      dropShadowHeight = 0;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 0;
    }

    return Padding(
      padding: EdgeInsets.only(top: widget.isDisabled == true ? 4 : paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled == true ? null : widget.onTap,
        onTapDown: widget.isDisabled == true
            ? null
            : (details) {
                setState(() {
                  isPressed = true;
                });
              },
        onTapCancel: widget.isDisabled == true
            ? null
            : () {
                setState(() {
                  isPressed = false;
                });
              },
        onTapUp: widget.isDisabled == true
            ? null
            : (details) {
                setState(() {
                  isPressed = false;
                });
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.isSecondary == true
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.onPrimaryContainer,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.only(
              bottom: widget.isDisabled == true ? 0 : dropShadowHeight),
          child: Container(
              width: MediaQuery.sizeOf(context).width * .9,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isDisabled == true
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : widget.isSecondary == true
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.primaryContainer,
              ),
              child: getChild()),
        ),
      ),
    );
  }

  Widget getChild() {
    if (widget.isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.leftIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8), child: widget.leftIcon),
          Text(
            widget.text,
            style: widget.isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      );
    }
    if (widget.rightIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: widget.isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8), child: widget.leftIcon),
        ],
      );
    }
    if (widget.leadingImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.leadingImage!,
            Text(
              widget.text,
              style: widget.isDisabled == true
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
        widget.text,
        style: widget.isDisabled == true
            ? Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline)
            : Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
