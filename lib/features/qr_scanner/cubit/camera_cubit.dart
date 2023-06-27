import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraInitial());
  Future<void> scanQrCode(String? barcode) async {
    if (barcode == null) {
      emit(const CameraInitial());
      return;
    }
    final barcodeUri = Uri.parse(barcode);
    final mediumId = barcodeUri.queryParameters['code'];
    if (mediumId == null) {
      emit(const CameraError(feedback: 'Invalid QR Code'));
      return;
    }
    emit(CameraScanned(qrValue: mediumId));
    return;
  }
}
