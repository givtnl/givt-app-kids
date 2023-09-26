import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/history/history_logic/repositories/allowance_repository.dart';
import 'package:givt_app_kids/features/history/history_logic/repositories/donation_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.donationsRepo, this.allowancesRepo)
      : super(const HistoryState());
  final DonationHistoryRepository donationsRepo;
  final AllowanceHistoryRepository allowancesRepo;

  FutureOr<void> fetchHistory(String childId) async {
    emit(state.copyWith(status: HistroryStatus.loading));

    try {
      List<dynamic> history = [];
      final donationHistory =
          await donationsRepo.fetchDonationHistory(childId: childId);
      history.addAll(donationHistory);
      final allowanceHistory =
          await allowancesRepo.fetchAllowanceHistory(childId: childId);
      history.addAll(allowanceHistory);
      history.sort((a, b) => b.date.compareTo(a.date));
      emit(state.copyWith(status: HistroryStatus.loaded, history: history));
    } catch (e) {
      emit(state.copyWith(status: HistroryStatus.error, error: e.toString()));
    }
  }
}
