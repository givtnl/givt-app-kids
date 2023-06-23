import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/organisation/cubit/organisation_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/widgets/camera_screen_frame.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
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
    return BlocProvider(
      create: (context) => CameraCubit(),
      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraScanned) {
            context
                .read<OrganisationCubit>()
                .getOrganisationDetails(state.qrValue);
          }
        },
        builder: (context, state) {
          return CameraScreenFrame(
            feedback: state.feedback,
            child: Stack(
              children: [
                BlocListener<OrganisationCubit, OrganisationState>(
                  listener: (context, orgState) {
                    if (orgState is OrganisationSet) {
                      AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.qrCodeScanned,
                          eventProperties: {
                            'goal_name': orgState.organisation.name,
                          });
                      // TODO: Add navigation to the next screen
                    }
                  },
                  child: MobileScanner(
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
      ),
    );
  }
}
