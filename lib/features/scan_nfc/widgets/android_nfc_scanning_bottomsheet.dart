import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/coin_ready_animated_widget.dart';
import 'package:go_router/go_router.dart';

class ScanningNfcAnimation extends StatelessWidget {
  const ScanningNfcAnimation({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.outline,
                minimumSize: const Size(double.maxFinite, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                context.pop();
                scanNfcCubit.cancelScanning();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}
