import 'package:flutter/material.dart';

class GivtButtonWrapper extends StatefulWidget {
  const GivtButtonWrapper({
    super.key,
    this.isDisabled,
    required this.child,
    required this.onTap,
  });

  final bool? isDisabled;
  final Widget child;
  final VoidCallback? onTap;

  @override
  _GivtButtonWrapperState createState() => _GivtButtonWrapperState();
}

class _GivtButtonWrapperState extends State<GivtButtonWrapper> {
  double dropShadowHeight = 4;
  double paddingtop = 4;

  @override
  void initState() {
    if (widget.isDisabled == true) {
      dropShadowHeight = 0;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.isDisabled == true ? 4 : paddingtop),
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
        child: widget.child,
      ),
    );
  }
}
