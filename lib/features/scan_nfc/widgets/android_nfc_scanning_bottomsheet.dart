import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ScanningNfcAnimation extends StatelessWidget {
  const ScanningNfcAnimation({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Hold your coin to the back\nof the phone',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Container(
          // hardcoded size from design file
          height: 160,
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: Lottie.asset(
            "assets/lotties/coin_3d.json",
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GivtElevatedSecondaryButton(
            onTap: () {
              context.pop();
              scanNfcCubit.cancelScanning();
            },
            text: 'Cancel',
          ),
        )
      ],
    );
  }
}
