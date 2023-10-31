import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nfc_manager/nfc_manager.dart';

part 'test_nfc_state.dart';

class TestNfcCubit extends Cubit<TestNfcState> {
  TestNfcCubit() : super(TestNfcInitial());
  void testNfc() async {
    emit(TestNfcScanning());
    dynamic result;

    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        result = tag.data;
        NfcManager.instance.stopSession();
      });

      emit(TestNfcScanned(result: result.toString()));
    }

    if (!isAvailable) {
      emit(const TestNfcScanned(result: 'NFC Manager not available'));
    }
  }
}
