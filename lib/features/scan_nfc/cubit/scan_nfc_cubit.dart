import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:nfc_manager/nfc_manager.dart';

part 'scan_nfc_state.dart';

class ScanNfcCubit extends Cubit<ScanNfcState> {
  ScanNfcCubit()
      : super(const ScanNfcState(
            coinAnimationStatus: CoinAnimationStatus.initial,
            scanNFCStatus: ScanNFCStatus.initial));

  void startAnimation() async {
    emit(state.copyWith(
      coinAnimationStatus: CoinAnimationStatus.animating,
    ));
  }

  void stopSimulation() {
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.initial,
    ));
  }

  void tagRead() async {
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.scanning,
    ));
    try {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        log('ios coin discovered: ${tag.data}');
        var ndef = Ndef.from(tag);
        if (ndef != null && ndef.cachedMessage != null) {
          if (ndef.cachedMessage!.records.isNotEmpty &&
              ndef.cachedMessage!.records.first.typeNameFormat ==
                  NdefTypeNameFormat.nfcWellknown) {
            final wellKnownRecord = ndef.cachedMessage!.records.first;
            if (wellKnownRecord.payload.first == 0x02) {
              final languageCodeAndContentBytes =
                  wellKnownRecord.payload.skip(1).toList();
              final languageCodeAndContentText =
                  utf8.decode(languageCodeAndContentBytes);
              final payload = languageCodeAndContentText.substring(2);
              log('ios coin payload: $payload');
              emit(state.copyWith(
                  result: payload,
                  scanNFCStatus: ScanNFCStatus.scanned,
                  coinAnimationStatus: CoinAnimationStatus.stoped));
            } else {
              final decoded = utf8.decode(wellKnownRecord.payload);
              log('ios coin decoded: $decoded');
              emit(state.copyWith(
                  result: decoded,
                  scanNFCStatus: ScanNFCStatus.scanned,
                  coinAnimationStatus: CoinAnimationStatus.stoped));
            }
          }
        }
      });
    } catch (e) {
      emit(state.copyWith(
          scanNFCStatus: ScanNFCStatus.error,
          coinAnimationStatus: CoinAnimationStatus.stoped));
    }
    NfcManager.instance.stopSession();
  }
}
