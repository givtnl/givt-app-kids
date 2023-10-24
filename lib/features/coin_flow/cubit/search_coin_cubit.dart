import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_coin_state.dart';

class SearchCoinCubit extends Cubit<SearchCoinState> {
  SearchCoinCubit()
      : super(SearchCoinState(
            status: CoinAnimationStatus.initial, stopwatch: Stopwatch()));

  static const searchDuration = Duration(milliseconds: 2000);

  void startAnimation() async {
    log('startAnimation');
    emit(state.copyWith(
      status: CoinAnimationStatus.animating,
      stopwatch: state.stopwatch..start(),
    ));
  }

  void stopAnimation(SearchCoinState state) {
    log('stopAnimation');
    emit(state.copyWith(
      status: CoinAnimationStatus.stoped,
      stopwatch: state.stopwatch..stop(),
    ));
  }
}
