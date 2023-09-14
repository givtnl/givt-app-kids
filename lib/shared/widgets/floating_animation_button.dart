import 'package:flutter/material.dart';

class FloatingAnimationButton extends StatelessWidget {
  const FloatingAnimationButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String text;
  final void Function()? onPressed;
  final bool isLoading;

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
            backgroundColor: const Color(0xFF54A1EE),
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
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
