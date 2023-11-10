import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class GiveOptionButton extends StatelessWidget {
  const GiveOptionButton(
      {required this.context,
      required this.size,
      required this.text,
      required this.imageLocation,
      required this.backgroundColor,
      required this.secondColor,
      required this.onPressed,
      super.key});
  final BuildContext context;
  final Size size;
  final String text;
  final String imageLocation;
  final Color backgroundColor;
  final Color secondColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: secondColor.withOpacity(0.25),
            width: 2,
          ),
        ),
      ),
      child: SizedBox(
        width: size.width * 0.5 - size.width * 0.15,
        height: size.width * 0.5 - size.width * 0.15,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imageLocation),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTheme.actionButtonStyle.copyWith(
                fontSize: 20,
                color: secondColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
