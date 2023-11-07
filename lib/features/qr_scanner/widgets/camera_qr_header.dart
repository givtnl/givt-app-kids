import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';

class CameraQrHeader extends StatelessWidget {
  const CameraQrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppTheme.offWhite,
        width: double.infinity,
        child: const Row(
          children: [
            GivtBackButton(),
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
