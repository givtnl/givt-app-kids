import 'package:flutter/material.dart';

class LabelElevatedButton extends StatefulWidget {
  const LabelElevatedButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
  });

  final VoidCallback onTap;
  final bool isDisabled;
  @override
  _LabelElevatedButtonState createState() => _LabelElevatedButtonState();
}

class _LabelElevatedButtonState extends State<LabelElevatedButton> {
  double dropShadowHeight = 6;

  @override
  void initState() {
    widget.isDisabled ? dropShadowHeight = 0 : dropShadowHeight = 6;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .7,
      height: 58,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF005231),
          backgroundColor: const Color(0xFF60DD9B),
          foregroundColor: const Color(0xFF005231),
        ),
        child: const Center(
          child: Text(
            'Label',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
