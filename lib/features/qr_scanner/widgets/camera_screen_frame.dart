import 'package:flutter/material.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/shared/widgets/heading_3.dart';

class CameraScreenFrame extends StatelessWidget {
  const CameraScreenFrame(
      {required this.child, required this.feedback, super.key});
  final Widget child;
  final String feedback;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading2(
          text: "Scan the Givt\nQR code",
          alignment: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
        leading: const GivtBackButton(),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(flex: 6, child: child),
          Expanded(
            child: Header3(
              name: feedback,
            ),
          )
        ],
      ),
    );
  }
}
