part of 'test_nfc_cubit.dart';

sealed class TestNfcState extends Equatable {
  const TestNfcState();

  @override
  List<Object> get props => [];
}

final class TestNfcInitial extends TestNfcState {}

final class TestNfcScanning extends TestNfcState {}

final class TestNfcScanned extends TestNfcState {
  final String result;

  const TestNfcScanned({required this.result});

  @override
  List<Object> get props => [result];
}
