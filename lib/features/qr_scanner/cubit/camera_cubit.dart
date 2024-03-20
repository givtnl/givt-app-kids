import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraInitial());
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
