import 'package:flutter/material.dart';

class FloatingActoinButton extends StatelessWidget {
  const FloatingActoinButton({
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFF54A1EE),
    this.foregroundColor = Colors.white,
    this.isLoading = false,
    super.key,
  });

  final String text;
  final void Function()? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 25),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: isLoading
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 25),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: foregroundColor,
                  ),
                )
              : Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 26,
                      color: foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
