import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class GivtFloatingActionButton extends StatelessWidget {
  const GivtFloatingActionButton({
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFF54A1EE),
    this.foregroundColor = Colors.white,
    this.isLoading = false,
    this.margin,
    this.leading,
    super.key,
  });

  final String text;
  final void Function()? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? leading;
  final EdgeInsets? margin;

  static const double _height = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      margin: margin ?? const EdgeInsets.only(left: 24, right: 24, bottom: 25),
      alignment: Alignment.center,
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
            : Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: AppTheme.actionButtonStyle.copyWith(
                          color: foregroundColor,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  if (leading != null)
                    Positioned(
                      left: -5,
                      child: Container(
                        height: _height,
                        width: _height,
                        padding: const EdgeInsets.all(5),
                        child: leading!,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
