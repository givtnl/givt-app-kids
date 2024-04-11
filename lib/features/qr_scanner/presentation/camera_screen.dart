import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/widgets/camera_screen_frame.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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
    Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        log('camera state changed to $state');
        if (state.status == CameraStatus.scanned) {
          log("QR code scanned: ${state.qrValue} \n Getting organisation details");
          context
              .read<OrganisationDetailsCubit>()
              .getOrganisationDetails(state.qrValue);
        }
        if (state.status == CameraStatus.permissionPermanentlyDeclined) {
          showDialog(
              context: context,
              builder: (_) {
                return _buildPermissionDialog(isSettings: true);
              });
        }
        if (state.status == CameraStatus.requestPermission) {
          showDialog(
              context: context,
              builder: (_) {
                return _buildPermissionDialog();
              });
        }
      },
      builder: (context, state) {
        return BlocConsumer<OrganisationDetailsCubit, OrganisationDetailsState>(
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
          },
          builder: (context, orgState) {
            return CameraScreenFrame(
              feedback: orgState is OrganisationDetailsErrorState
                  ? orgState.organisation.name
                  : state.feedback,
              child: Stack(
                children: [
                  state.status == CameraStatus.permissionGranted ||
                          state.status == CameraStatus.scanned
                      ? _buildMobileScanner(context.read<CameraCubit>())
                      : _buildDisabledCameraBox(),
                  Positioned.fill(
                    child: state.status == CameraStatus.scanned
                        ? _builCenterLoader()
                        : _buildQRCodeTarget(size),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionDialog({bool isSettings = false}) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/camera_dutone.svg",
                ),
                const SizedBox(height: 16),
                Text(
                  'Can we use the camera?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isSettings
                      ? 'To scan the QR Code we need to turn on the camera. Go to Settings to allow that.'
                      : 'To scan the QR Code we need to turn on the camera in the app. Press OK in the next screen to allow that.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                isSettings
                    ? GivtElevatedButton(
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvent.openAppPermissionsSettings,
                          );
                          openAppSettings();
                          context.pop();
                        },
                        text: 'Go to Settings',
                      )
                    : GivtElevatedButton(
                        onTap: () {
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvent.openCameraPermissionDialog,
                          );
                          context.read<CameraCubit>().grantAccess();
                          context.pop();
                        },
                        text: 'Next',
                      ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.xmark),
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.closePermissionsDialog,
                );
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileScanner(CameraCubit cameraCubit) {
    return MobileScanner(
      controller: _cameraController,
      onDetect: (barcode) async {
        if (cameraCubit.state.status == CameraStatus.scanned) return;
        await cameraCubit.scanQrCode(barcode);
      },
    );
  }

  Widget _buildDisabledCameraBox() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.disabledCameraGrey,
    );
  }

  Widget _buildQRCodeTarget(Size size) {
    return Center(
      child: SvgPicture.asset(
        "assets/images/qr_target_full.svg",
        width: size.width * 0.6,
        height: size.width * 0.6,
      ),
    );
  }

  Widget _builCenterLoader() {
    return const CustomCircularProgressIndicator();
  }
}
