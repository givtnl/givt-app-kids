import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';

class StartScanNfcButton extends StatefulWidget {
  const StartScanNfcButton({super.key});

  @override
  State<StartScanNfcButton> createState() => _StartScanNfcButtonState();
}

class _StartScanNfcButtonState extends State<StartScanNfcButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: context.read<ScanNfcCubit>().tagRead,
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