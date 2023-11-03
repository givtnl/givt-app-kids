import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/widgets/camera_screen_frame.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/qr_code_target.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

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
          log('camera state changed to $state');
          if (state is CameraScanned) {
            log("QR code scanned: ${state.qrValue} \n Getting organisation details");
            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(state.qrValue);
          }
        },
        builder: (context, state) {
          return BlocConsumer<OrganisationDetailsCubit,
              OrganisationDetailsState>(
            listener: (context, orgState) {
              log('organisation details state changed to $orgState');
              if (orgState is OrganisationDetailsSetState) {
                log("Organisation is set: ${orgState.organisation.name}");
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.qrCodeScanned,
                    eventProperties: {
                      'goal_name': orgState.organisation.name,
                    });
                context.pushReplacementNamed(Pages.chooseAmountSlider.name);
              }
              ;
            },
            builder: (context, orgState) {
              return CameraScreenFrame(
                feedback: orgState is OrganisationDetailsErrorState
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
