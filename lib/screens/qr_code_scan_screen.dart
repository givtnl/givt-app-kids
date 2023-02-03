// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

//import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';
import 'package:givt_app_kids/widgets/qr_code_target.dart';
import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;
import 'package:givt_app_kids/screens/choose_amount_slider_screen.dart';

class QrCodeScanScreen extends StatefulWidget {
  static const String routeName = "/qr-code-scan";

  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
  bool _isQrCodeDetected = false;

  @override
  void initState() {
    super.initState();

    //temporary code to test on iOS simulators
    if (kDebugMode && Platform.isIOS) {
      Future.delayed(
        Duration(seconds: 3),
      ).then(
        (_) {
          Navigator.of(context).pushNamed(
            ChooseAmountSliderScreen.routeName,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                  color: Color(0xFFEEEDE4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      custom_widgets.BackButton(),
                      Expanded(
                        child: Text(
                          "Scan the Givt\nQR code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B3240),
                          ),
                        ),
                      ),
                      SizedBox(width: 55,),
                    ],
                  )),
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
                        if (!_isQrCodeDetected) {
                          _isQrCodeDetected = true;
                          Navigator.of(context).pushNamed(
                            ChooseAmountSliderScreen.routeName,
                          );
                          final String code = barcode.rawValue!;
                          print('Barcode found! $code');
                        }
                      }
                    },
                  ),
                  Positioned.fill(
                    child: QrCodeTarget(),
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
