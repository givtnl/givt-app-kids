import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial(isLoading: false));
  void isLoadingOn() => emit(CameraInitial(isLoading: true));
  void scanQrCode(String? qrCode) {
    if (qrCode == null) {
      emit(const CameraInitial());
      return;
    }
    fakeDelay();
    emit(const CameraLoading());
  }

  void fakeDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(CameraScanned(qrValue: '1234567890'));
  }
}
