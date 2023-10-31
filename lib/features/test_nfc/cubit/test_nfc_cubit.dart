import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nfc_manager/nfc_manager.dart';

part 'test_nfc_state.dart';

class TestNfcCubit extends Cubit<TestNfcState> {
  TestNfcCubit() : super(TestNfcInitial());
  void testNfc() async {
    emit(TestNfcScanning());
    String result = '';

    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        if (ndef == null) {
          result = 'Tag is not compatible with NDEF';
          return;
        }
        final cachedMessage = ndef.cachedMessage;
        if (cachedMessage == null) {
          result = 'No records found on this tag';
          return;
        }
        result =
            'There are ${cachedMessage.records.length.toString()} cached records on this tag';
      });
      NfcManager.instance.stopSession();

      emit(TestNfcScanned(result: result));
    }

    if (!isAvailable) {
      emit(const TestNfcScanned(result: 'NFC Manager not available'));
    }
  }
}
