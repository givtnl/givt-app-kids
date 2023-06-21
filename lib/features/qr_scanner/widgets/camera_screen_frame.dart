import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/qr_scanner/widgets/camera_qr_header.dart';
import 'package:givt_app_kids/widgets/heading_3.dart';

class CameraScreenFrame extends StatelessWidget {
  const CameraScreenFrame(
      {required this.child, required this.feedback, super.key});
  final Widget child;
  final String feedback;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEDE4),
        body: Column(
          children: [
            const CameraQrHeader(),
            Expanded(flex: 6, child: child),
            Expanded(
              child: Header3(
                name: feedback,
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
