import 'package:flutter/material.dart';

class LabelButton extends StatefulWidget {
  const LabelButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
  });

  final VoidCallback onTap;
  final bool isDisabled;
  @override
  _LabelButtonState createState() => _LabelButtonState();
}

class _LabelButtonState extends State<LabelButton> {
  double dropShadowHeight = 6;
  double paddingtop = 6;

  @override
  void initState() {
    widget.isDisabled ? dropShadowHeight = 0 : dropShadowHeight = 6;
    widget.isDisabled ? paddingtop = 6 : paddingtop = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : widget.onTap,
        onTapDown: widget.isDisabled
            ? null
            : (details) {
                setState(() {
                  dropShadowHeight = 0;
                  paddingtop = 6;
                });
              },
        onTapCancel: widget.isDisabled
            ? null
            : () {
                setState(() {
                  dropShadowHeight = 6;
                  paddingtop = 0;
                });
              },
        onTapUp: widget.isDisabled
            ? null
            : (details) {
                setState(() {
                  dropShadowHeight = 6;
                  paddingtop = 0;
                });
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF005231),
                blurRadius: 0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: dropShadowHeight),
          child: Container(
            width: MediaQuery.sizeOf(context).width * .7,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF60DD9B),
            ),
            child: const Center(
              child: Text(
                'Label',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
