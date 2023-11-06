import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/coin_ready_animated_widget.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class ScanningNfcAnimation extends StatelessWidget {
  const ScanningNfcAnimation({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Ready to scan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        const Padding(
            padding: EdgeInsets.all(20), child: CoinReadyAnimatedWidget()),
        const Text('Tap your coin to the back\nof the screen',
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.greyButtonColor,
            minimumSize: const Size(double.maxFinite, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            context.pop();
            scanNfcCubit.stopSimulation();
          },
          child: const Text(
            'Cancel',
            style: AppTheme.actionButtonStyle,
          ),
        )
      ],
    );
  }
}
