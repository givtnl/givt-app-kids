import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';

mixin HistoryRepository {
  Future<List<HistoryItem>> fetchHistory(
      {required String childId,
      required int pageNr,
      required HistoryTypes type});
}

class HistoryRepositoryImpl with HistoryRepository {
  HistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<HistoryItem>> fetchHistory(
      {required String childId,
      required int pageNr,
      required HistoryTypes type}) async {
    final response =
        await _apiService.fetchHistory(childId, type.value, pageNr);

    ///
    /// DEAL WITH DONATION VS ALLOWANCE
    ///
    List<HistoryItem> result = [];
    for (final donationMap in response) {
      result.add(HistoryItem.fromMap(donationMap));
    }
    return result;
  }
}
