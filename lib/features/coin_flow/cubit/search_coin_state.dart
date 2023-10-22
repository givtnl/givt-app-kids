part of 'search_coin_cubit.dart';

enum CoinAnimationStatus {
  initial,
  started,
  animating,
  stoped,
}

class SearchCoinState extends Equatable {
  const SearchCoinState({
    required this.status,
    required this.stopwatch,
  });
  final CoinAnimationStatus status;
  final Stopwatch stopwatch;
  @override
  List<Object> get props => [status, stopwatch];

  SearchCoinState copyWith({
    CoinAnimationStatus? status,
    Stopwatch? stopwatch,
  }) {
    return SearchCoinState(
      status: status ?? this.status,
      stopwatch: stopwatch ?? this.stopwatch,
    );
  }
}
