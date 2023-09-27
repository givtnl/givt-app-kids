import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/history/history_logic/history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.historyRepo) : super(const HistoryState());
  final DonationHistoryRepository historyRepo;

  FutureOr<void> fetchHistory(String childId) async {
    emit(state.copyWith(status: HistroryStatus.loading));

    try {
      List<dynamic> history = [];
      history.addAll(state.history);
      // fetch donations
      final donationHistory = await historyRepo.fetchHistory(
          childId: childId, pageNr: state.pageNr, type: HistoryTypes.donation);
      history.addAll(donationHistory);
      // fetch allowances
      final allowanceHistory = await historyRepo.fetchHistory(
          childId: childId, pageNr: state.pageNr, type: HistoryTypes.allowance);
      history.addAll(allowanceHistory);
      // sort from newest to oldest
      history.sort((a, b) => b.date.compareTo(a.date));
      // check if they reached end of history
      // if end of history do not increment page nr
      if (donationHistory.isEmpty && allowanceHistory.isEmpty) {
        emit(state.copyWith(status: HistroryStatus.loaded, history: history));
        return;
      }
      // update state
      emit(state.copyWith(
          status: HistroryStatus.loaded,
          history: history,
          pageNr: state.pageNr + 1));
    } catch (e) {
      emit(state.copyWith(status: HistroryStatus.error, error: e.toString()));
    }
  }
}
