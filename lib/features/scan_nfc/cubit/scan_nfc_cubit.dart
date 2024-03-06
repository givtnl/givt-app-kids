import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:nfc_manager/nfc_manager.dart';

part 'scan_nfc_state.dart';

class ScanNfcCubit extends Cubit<ScanNfcState> {
  ScanNfcCubit()
      : super(const ScanNfcState(
            coinAnimationStatus: CoinAnimationStatus.initial,
            scanNFCStatus: ScanNFCStatus.ready));

  static const foundDelay = Duration(milliseconds: 1600);

  static const _closeIOSScanningScheetDelay = Duration(milliseconds: 2900);

  void cancelScanning() {
    NfcManager.instance.stopSession();
    emit(state.copyWith(scanNFCStatus: ScanNFCStatus.ready));
  }

  void startAnimation() {
    emit(state.copyWith(
      coinAnimationStatus: CoinAnimationStatus.animating,
      scanNFCStatus: ScanNFCStatus.ready,
    ));
  }

  void readTag({Duration prescanningDelay = Duration.zero}) async {
    AnalyticsHelper.logEvent(eventName: AmplitudeEvent.startScanningCoin);

    emit(state.copyWith(
      scanNFCStatus: ScanNFCStatus.scanning,
    ));

    // When the device is not a physical device, we can't scan NFC
    // so we simulate a successful scan
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        emit(state.copyWith(
            mediumId: OrganisationDetailsCubit.defaultMediumId,
            readData: '',
            scanNFCStatus: ScanNFCStatus.scanned,
            coinAnimationStatus: CoinAnimationStatus.stopped));
        return;
      }
    }
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          emit(state.copyWith(
              mediumId: OrganisationDetailsCubit.defaultMediumId,
              readData: '',
              scanNFCStatus: ScanNFCStatus.scanned,
              coinAnimationStatus: CoinAnimationStatus.stopped));
        });
        return;
      }
    }

    try {
      NfcManager.instance.startSession(
          alertMessage: 'Tap your coin to the top\nof the iPhone',
          onError: (error) async {
            log('coin read error: ${error.message}');
            if (error.type != NfcErrorType.systemIsBusy) {
              cancelScanning();
            }
          },
          onDiscovered: (NfcTag tag) async {
            log('coin discovered: ${tag.data}');
            var ndef = Ndef.from(tag);
            if (ndef != null && ndef.cachedMessage != null) {
              if (ndef.cachedMessage!.records.isNotEmpty &&
                  ndef.cachedMessage!.records.first.typeNameFormat ==
                      NdefTypeNameFormat.nfcWellknown) {
                String mediumId = '';
                String readData = '';
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
                await NfcManager.instance.stopSession(alertMessage: ' ');
                if (Platform.isIOS) {
                  await Future.delayed(_closeIOSScanningScheetDelay);
                }

                emit(state.copyWith(
                    mediumId: mediumId,
                    readData: readData,
                    scanNFCStatus: ScanNFCStatus.scanned,
                    coinAnimationStatus: CoinAnimationStatus.stopped));
              }
            }
          });
    } catch (e, stackTrace) {
      LoggingInfo.instance.error('Error while scanning coin: $e',
          methodName: stackTrace.toString());

      emit(state.copyWith(
          scanNFCStatus: ScanNFCStatus.error,
          coinAnimationStatus: CoinAnimationStatus.stopped));
      NfcManager.instance.stopSession();
      AnalyticsHelper.logEvent(eventName: AmplitudeEvent.coinScannedError);
    }
  }
}
