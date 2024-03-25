import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraInitial());

  static String cameraPermissionAskedKey = 'iOSCameraPermissionAsked';
  static Duration permisionDialogDelay = const Duration(milliseconds: 300);
  void checkPermission() async {
    emit(const CameraPermissionCheck());
    final status = await Permission.camera.status;
    //delay is from design
    Future.delayed(permisionDialogDelay);

    // iOS returns denied status in case
    // the user was not asked for permissions yet or
    // it was permanently denied
    if (status.isDenied && Platform.isIOS) {
      final iOSCameraPermissionAsked =
          getIt<SharedPreferences>().getBool(cameraPermissionAskedKey);
      // if it is the first time asking for permission on iOS, remember it
      if (iOSCameraPermissionAsked == null) {
        getIt<SharedPreferences>().setBool(cameraPermissionAskedKey, true);
        emit(const CameraPermissionRequest());
        return;
      }
      emit(const CameraPermissionPermanentlyDeclined());
      return;
    }

    if (status.isDenied) {
      emit(const CameraPermissionRequest());
      return;
    }
    // android only status, once a user denied permission twice
    if (status.isPermanentlyDenied) {
      emit(const CameraPermissionPermanentlyDeclined());
      return;
    }

    emit(const CameraPermissionGranted());
  }

  void grantAccess() async {
    emit(const CameraPermissionGranted());
  }

  Future<void> scanQrCode(BarcodeCapture barcode) async {
    if (barcode.barcodes.isEmpty) {
      emit(const CameraInitial());
      return;
    }

    for (final barcode in barcode.barcodes) {
      if (barcode.rawValue == null) continue;
      final barcodeUri = Uri.parse(barcode.rawValue!);

      if (barcodeUri.queryParameters['code'] == null) continue;
      final mediumId = barcodeUri.queryParameters['code']!;

      emit(CameraScanned(qrValue: mediumId));
      return;
    }

    emit(const CameraError(feedback: 'Invalid QR Code'));
  }
}
