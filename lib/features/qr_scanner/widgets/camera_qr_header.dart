import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';

class CameraQrHeader extends StatelessWidget {
  const CameraQrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          color: Color(0xFFEEEDE4),
          width: double.infinity,
          child: Row(
            children: [
              const BackButton(),
              Expanded(
                child: Heading2(
                  text: "Scan the Givt\nQR code",
                  alignment: TextAlign.center,
                ),
              ),
              const SizedBox(width: 50),
            ],
          )),
    );
  }
}
