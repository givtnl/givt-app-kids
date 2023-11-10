import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_coin_state.dart';

class SearchCoinCubit extends Cubit<SearchCoinState> {
  SearchCoinCubit()
      : super(SearchCoinState(
            status: CoinAnimationStatus.initial, stopwatch: Stopwatch()));

  static const searchDuration = Duration(milliseconds: 2000);

  void startAnimation() async {
    emit(state.copyWith(
      status: CoinAnimationStatus.animating,
      stopwatch: state.stopwatch..start(),
    ));
  }

  void stopAnimation() async {
    // checking if the request took less than the animation duration
    if (state.stopwatch.elapsedMilliseconds <
        SearchCoinCubit.searchDuration.inMilliseconds) {
      await Future.delayed(
        SearchCoinCubit.searchDuration -
            Duration(
              milliseconds: state.stopwatch.elapsedMilliseconds,
            ),
      );
    }
    emit(state.copyWith(
      status: CoinAnimationStatus.stopped,
      stopwatch: state.stopwatch..stop(),
    ));
  }

  void error() {
    emit(state.copyWith(
      status: CoinAnimationStatus.error,
      stopwatch: state.stopwatch..reset(),
    ));
  }
}
