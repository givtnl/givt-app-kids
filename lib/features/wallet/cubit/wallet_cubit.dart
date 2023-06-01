import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState(walletValue: 0));

  void increment() => emit(WalletState(walletValue: state.walletValue + 1));

  void decrememt() => emit(WalletState(walletValue: state.walletValue - 1));
}
