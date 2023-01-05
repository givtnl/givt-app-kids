// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';

class QrCodeScanScreen extends StatefulWidget {
  static const String routeName = "/qr-code-scan";

  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {

  // @override
  // void initState() {
  //   super.initState();

  //   //temporary code to test on iOS simulators
  //   Future.delayed(
  //     Duration(seconds: 3),
  //   ).then(
  //     (_) {
  //       Navigator.of(context).pushNamed(
  //         ChooseAmountScreenV4.routeName,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                color: Color(0xFFF1EAE2),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Scan the Givt QR code",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E7AB5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    allowDuplicates: false,
                    fit: BoxFit.fitWidth,
                    onDetect: (barcode, args) {
                      if (barcode.rawValue == null) {
                        print('Failed to scan Barcode');
                      } else {
                        Navigator.of(context).pushNamed(
                          ChooseAmountScreenV4.routeName,
                        );
                        final String code = barcode.rawValue!;
                        print('Barcode found! $code');
                      }
                    },
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Image(
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/qr_target.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
