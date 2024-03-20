import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class QrCodeTarget extends StatelessWidget {
  const QrCodeTarget({
    super.key,
    this.targetCornerSize = 80,
    this.targetColor = const Color(0xFF3B3240),
  });

  final double targetCornerSize;
  final Color targetColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/images/target_left_top.svg",
                width: targetCornerSize,
                height: targetCornerSize,
                colorFilter: ColorFilter.mode(targetColor, BlendMode.srcIn),
              ),
              SizedBox(width: targetCornerSize),
              SvgPicture.asset(
                "assets/images/target_right_top.svg",
                width: targetCornerSize,
                height: targetCornerSize,
                colorFilter: ColorFilter.mode(targetColor, BlendMode.srcIn),
              ),
            ],
          ),
          SizedBox(height: targetCornerSize),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/images/target_left_bottom.svg",
                width: targetCornerSize,
                height: targetCornerSize,
                colorFilter: ColorFilter.mode(targetColor, BlendMode.srcIn),
              ),
              SizedBox(width: targetCornerSize),
              SvgPicture.asset(
                "assets/images/target_right_bottom.svg",
                width: targetCornerSize,
                height: targetCornerSize,
                colorFilter: ColorFilter.mode(targetColor, BlendMode.srcIn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
