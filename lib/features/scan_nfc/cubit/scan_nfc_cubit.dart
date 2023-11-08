import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
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

  void stopScanning() {
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.initial,
    ));
  }

  void tagRead() {
    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.scanning,
    ));
    try {
      NfcManager.instance.startSession(
          alertMessage: 'Tap your coin to the top\nof the iPhone',
          onDiscovered: (NfcTag tag) async {
            log('coin discovered: ${tag.data}');
            var ndef = Ndef.from(tag);
            String mediumId = OrganisationDetailsCubit.defaultMediumId;

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
                } else {
                  final decoded = utf8.decode(wellKnownRecord.payload);
                  log('coin decoded: $decoded');
                  Uri uri = Uri.parse(decoded);
                  mediumId = uri.queryParameters['code'] ?? mediumId;
                }
                emit(state.copyWith(
                    result: mediumId,
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
