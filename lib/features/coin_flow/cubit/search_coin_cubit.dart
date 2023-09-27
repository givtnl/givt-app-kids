import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_coin_state.dart';

class SearchCoinCubit extends Cubit<SearchCoinState> {
  SearchCoinCubit() : super(const SearchCoinInitialState());

  static const searchDuration = Duration(milliseconds: 2000);

  Future<void> searchForCoin() async {
    emit(const SearchCoinAnimationState());
    await Future.delayed(searchDuration);
    emit(const SearchCoinFoundedState());
  }
}
