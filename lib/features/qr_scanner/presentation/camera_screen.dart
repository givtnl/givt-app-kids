import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/organisation/cubit/organisation_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/cubit/camera_cubit.dart';
import 'package:givt_app_kids/features/organisation/presentation/mock_slider_screen.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
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
                    Navigator.of(context).pushReplacementNamed(
                      MockSliderScreen.routeName,
                    );
                  }
                },
                child: MobileScanner(
                  controller: _cameraController,
                  onDetect: (barcode, args) async {
                    if (state.isLoading) {
                      return;
                    }
                    if (state is CameraScanned == false) {
                      await context
                          .read<CameraCubit>()
                          .scanQrCode(barcode.rawValue);
                    }
                  },
                ),
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
        );
      },
    );
  }
}
