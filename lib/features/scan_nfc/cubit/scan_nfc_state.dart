part of 'scan_nfc_cubit.dart';

enum ScanNFCStatus {
  initial,
  scanning,
  scanned,
  error,
}

class ScanNfcState extends Equatable {
  const ScanNfcState({
    required this.coinAnimationStatus,
    required this.scanNFCStatus,
    this.result = '',
  });
  final CoinAnimationStatus coinAnimationStatus;
  final ScanNFCStatus scanNFCStatus;
  final String result;

  @override
  List<Object> get props => [scanNFCStatus, coinAnimationStatus, result];

  ScanNfcState copyWith({
    CoinAnimationStatus? coinAnimationStatus,
    ScanNFCStatus? scanNFCStatus,
    String? result,
  }) {
    return ScanNfcState(
      coinAnimationStatus: coinAnimationStatus ?? this.coinAnimationStatus,
      scanNFCStatus: scanNFCStatus ?? this.scanNFCStatus,
      result: result ?? this.result,
    );
  }
}
