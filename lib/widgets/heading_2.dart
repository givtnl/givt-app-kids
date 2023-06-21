import 'package:flutter/material.dart';

class Heading2 extends StatelessWidget {
  Heading2({super.key, required this.text, this.alignment = TextAlign.start});
  String text;
  TextAlign alignment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: alignment,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    );
  }
}
