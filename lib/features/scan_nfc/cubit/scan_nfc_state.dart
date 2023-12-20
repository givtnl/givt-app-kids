part of 'scan_nfc_cubit.dart';

enum ScanNFCStatus {
  ready,
  scanning,
  scanned,
  error,
}

class ScanNfcState extends Equatable {
  const ScanNfcState({
    required this.coinAnimationStatus,
    required this.scanNFCStatus,
    this.readData = '',
    this.mediumId = '',
  });
  final CoinAnimationStatus coinAnimationStatus;
  final ScanNFCStatus scanNFCStatus;
  final String readData;
  final String mediumId;

  @override
  List<Object> get props =>
      [scanNFCStatus, coinAnimationStatus, readData, mediumId];

  ScanNfcState copyWith({
    CoinAnimationStatus? coinAnimationStatus,
    ScanNFCStatus? scanNFCStatus,
    String? readData,
    String? mediumId,
  }) {
    return ScanNfcState(
      coinAnimationStatus: coinAnimationStatus ?? this.coinAnimationStatus,
      scanNFCStatus: scanNFCStatus ?? this.scanNFCStatus,
      readData: readData ?? this.readData,
      mediumId: mediumId ?? this.mediumId,
    );
  }
}
