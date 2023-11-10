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

  static const startDelay = Duration(milliseconds: 1600);
  static const foundDelay = Duration(milliseconds: 4000);

  void cancelScanning() {
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.cancelled,
    ));
  }

  void startTagRead({required Duration delay}) async {
    emit(state.copyWith(
      coinAnimationStatus: CoinAnimationStatus.animating,
      scanNFCStatus: ScanNFCStatus.initial,
    ));
    await Future.delayed(delay);
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.scanning,
    ));
    String mediumId = '';
    String readData = '';
    try {
      NfcManager.instance.startSession(
          alertMessage: 'Tap your coin to the top\nof the iPhone',
          onDiscovered: (NfcTag tag) async {
            log('coin discovered: ${tag.data}');
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
                  log('coin payload: $payload');
                  Uri uri = Uri.parse(payload);
                  mediumId = uri.queryParameters['code'] ?? mediumId;
                  readData = payload;
                } else {
                  final decoded = utf8.decode(wellKnownRecord.payload);
                  log('coin decoded: $decoded');
                  Uri uri = Uri.parse(decoded);
                  mediumId = uri.queryParameters['code'] ?? mediumId;
                  readData = decoded;
                }
                emit(state.copyWith(
                    mediumId: mediumId,
                    readData: readData,
                    scanNFCStatus: ScanNFCStatus.scanned,
                    coinAnimationStatus: CoinAnimationStatus.stopped));
                NfcManager.instance.stopSession();
              }
            }
          });
    } catch (e) {
      emit(state.copyWith(
          scanNFCStatus: ScanNFCStatus.error,
          coinAnimationStatus: CoinAnimationStatus.stopped));
      NfcManager.instance.stopSession();
    }
  }
}
