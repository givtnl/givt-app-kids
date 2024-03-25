import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
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

    if (status.isDenied) {
      emit(const CameraPermissionRequest());
      return;
    }

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
