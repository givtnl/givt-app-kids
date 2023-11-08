import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';

class StartScanNfcButton extends StatelessWidget {
  const StartScanNfcButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          final scanNfcCubit = context.read<ScanNfcCubit>();
          // use case: the user dimisses the bottom sheet without clicking the button
          if (scanNfcCubit.state.scanNFCStatus == ScanNFCStatus.scanning) {
            scanNfcCubit.stopScanning();
          }
          scanNfcCubit.tagRead();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.maxFinite, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          'Start',
          textAlign: TextAlign.center,
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
