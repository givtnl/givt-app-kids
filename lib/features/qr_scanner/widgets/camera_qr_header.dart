import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';

import 'package:givt_app_kids/shared/widgets/back_button.dart'
    as custom_widgets;

class CameraQrHeader extends StatelessWidget {
  const CameraQrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFFEEEDE4),
        width: double.infinity,
        child: const Row(
          children: [
            custom_widgets.BackButton(),
            Expanded(
              child: Heading2(
                text: "Scan the Givt\nQR code",
                alignment: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
