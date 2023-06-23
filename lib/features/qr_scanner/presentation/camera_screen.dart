import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/giving_flow/cubit/organisation/organisation_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/widgets/camera_screen_frame.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/widgets/qr_code_target.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../giving_flow/screens/choose_amount_slider_screen.dart';

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
    return BlocProvider(
      create: (context) => CameraCubit(),
      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraScanned) {
            log("QR code scanned: ${state.qrValue} \n Getting organisation details");
            context
                .read<OrganisationCubit>()
                .getOrganisationDetails(state.qrValue);
          }
        },
        builder: (context, state) {
          return BlocConsumer<OrganisationCubit, OrganisationState>(
            listener: (context, orgState) {
              if (orgState is OrganisationSet) {
                log("Organisation is set: ${orgState.organisation.name}");
                // AnalyticsHelper.logEvent(
                //     eventName: AmplitudeEvent.qrCodeScanned,
                //     eventProperties: {
                //       'goal_name': orgState.organisation.name,
                //     });
                Navigator.of(context)
                    .pushReplacementNamed(ChooseAmountSliderScreen.routeName);
              }
              ;
            },
            builder: (context, orgState) {
              return CameraScreenFrame(
                feedback: orgState is OrganisationError
                    ? orgState.organisation.name
                    : state.feedback,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _cameraController,
                      onDetect: (barcode, args) async {
                        if (state is CameraScanned) {
                          return;
                        }
                        await context
                            .read<CameraCubit>()
                            .scanQrCode(barcode.rawValue);
                      },
                    ),
                    Positioned.fill(
                      child: state is CameraScanned
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const QrCodeTarget(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
