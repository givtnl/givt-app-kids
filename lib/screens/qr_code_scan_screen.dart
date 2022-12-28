import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/goal_details_screen.dart';

class QrCodeScanScreen extends StatefulWidget {
  static const String routeName = "/qr-code-scan";

  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  _QrCodeScanScreenState createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.delayed(
  //     Duration(seconds: 5),
  //   ).then(
  //     (_) {
  //       Navigator.of(context).pushNamed(
  //         GoalDetailsScreen.routeName,
  //         arguments:
  //             Provider.of<GoalsProvider>(context, listen: false).qrCodeFlowGoal,
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Text(
                  "Scan the Givt QR code",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: MobileScanner(
                allowDuplicates: false,
                fit: BoxFit.fitWidth,
                onDetect: (barcode, args) {
                  if (barcode.rawValue == null) {
                    print('Failed to scan Barcode');
                  } else {
                    Navigator.of(context).pushNamed(
                      GoalDetailsScreen.routeName,
                      arguments:
                          Provider.of<GoalsProvider>(context, listen: false)
                              .qrCodeFlowGoal,
                    );
                    final String code = barcode.rawValue!;
                    print('Barcode found! $code');
                  }
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
