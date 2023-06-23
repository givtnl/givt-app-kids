import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';

class QrGiveButton extends StatelessWidget {
  const QrGiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(CameraScreen.routeName);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 60),
        backgroundColor: Color(0xFFE28D4D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: SvgPicture.asset("assets/images/qr_icon.svg"),
      label: const Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 10,
        ),
        child: Text(
          "I want to give",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF1EAE2),
          ),
        ),
      ),
    );
  }
}
