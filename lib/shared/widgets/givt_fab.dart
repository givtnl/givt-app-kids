import 'package:flutter/material.dart';

class GivtFAButton extends StatefulWidget {
  const GivtFAButton({
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
  _GivtFAButtonState createState() => _GivtFAButtonState();
}

class _GivtFAButtonState extends State<GivtFAButton> {
  double dropShadowHeight = 4;
  double paddingtop = 4;

  @override
  void initState() {
    widget.isDisabled == true ? dropShadowHeight = 0 : dropShadowHeight = 4;
    widget.isDisabled == true ? paddingtop = 4 : paddingtop = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled == true ? null : widget.onTap,
        onTapDown: widget.isDisabled == true
            ? null
            : (details) {
                setState(() {
                  dropShadowHeight = 0;
                  paddingtop = 4;
                });
              },
        onTapCancel: widget.isDisabled == true
            ? null
            : () {
                setState(() {
                  dropShadowHeight = 4;
                  paddingtop = 0;
                });
              },
        onTapUp: widget.isDisabled == true
            ? null
            : (details) {
                setState(() {
                  dropShadowHeight = 4;
                  paddingtop = 0;
                });
              },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: dropShadowHeight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: getChild(),
            )),
      ),
    );
  }

  Widget getChild() {
    if (widget.leftIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: widget.leftIcon),
            Text(
              widget.text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );
    }
    if (widget.rightIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: widget.rightIcon),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
