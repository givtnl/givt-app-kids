import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/organisation/cubit/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/organisation/widgets/camera_qr_header.dart';
import 'package:givt_app_kids/widgets/heading_3.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFEEEDE4),
            body: Column(
              children: [
                const CameraQrHeader(),
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      MobileScanner(
                        allowDuplicates: false,
                        controller: _cameraController,
                        fit: BoxFit.cover,
                        onDetect: (barcode, args) async {
                          dev.log('DETECTED QR CODE');
                          context
                              .read<CameraCubit>()
                              .scanQrCode(barcode.rawValue);
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
                      Positioned.fill(
                        child: state.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const QrCodeTarget(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Header3(
                  name: state.feedback,
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
