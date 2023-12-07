import 'package:flutter/material.dart';

class LabelInkwell extends StatefulWidget {
  const LabelInkwell({
    super.key,
    required this.isDisabled,
    required this.onTap,
  });

  final VoidCallback onTap;
  final bool isDisabled;
  @override
  _LabelInkwellState createState() => _LabelInkwellState();
}

class _LabelInkwellState extends State<LabelInkwell> {
  double dropShadowHeight = 6;

  @override
  void initState() {
    widget.isDisabled ? dropShadowHeight = 0 : dropShadowHeight = 6;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: const Color(0xFF60DD9B),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              splashColor: Color.fromARGB(255, 164, 255, 207),
              onTap: widget.isDisabled ? null : widget.onTap,
              onTapDown: widget.isDisabled
                  ? null
                  : (details) {
                      setState(() {
                        dropShadowHeight = 0;
                      });
                    },
              onTapCancel: widget.isDisabled
                  ? null
                  : () {
                      setState(() {
                        dropShadowHeight = 6;
                      });
                    },
              onTapUp: widget.isDisabled
                  ? null
                  : (details) {
                      setState(() {
                        dropShadowHeight = 6;
                      });
                    },
              child: const Center(
                child: Text(
                  'Label',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
