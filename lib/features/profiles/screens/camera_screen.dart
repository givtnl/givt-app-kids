import 'package:flutter/material.dart';
import 'package:givt_app_kids/widgets/qr_code_target.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  static const String routeName = "/camera-screen";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
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
                      BackButton(),
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
                      SizedBox(
                        width: 55,
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
//                    allowDuplicates: false,
                    controller: _cameraController,
                    fit: BoxFit.fitWidth,
                    onDetect: (barcode, args) async {
                      // if (_isLoading) {
                      //   return;
                      // }

                      // var organisation =
                      //     await _getOrganisationDetails(barcode.rawValue);
                      // if (organisation != null && mounted) {
                      //   AnalyticsHelper.logEvent(
                      //       eventName: AmplitudeEvent.qrCodeScanned,
                      //       eventProperties: {
                      //         'goal_name': organisation.name,
                      //       });
                      //   Navigator.of(context).pushReplacementNamed(
                      //     ChooseAmountSliderScreen.routeName,
                      //     arguments: organisation,
                      //   );
                      // }
                    },
                  ),
                  const Positioned.fill(
                    child: QrCodeTarget(),
                  ),
                  // if (_isLoading)
                  //   Positioned.fill(
                  //     child: Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
