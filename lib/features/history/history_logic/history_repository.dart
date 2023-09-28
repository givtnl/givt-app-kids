import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/features/history/models/history.dart';

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

    List<HistoryItem> result = [];

    for (final donationMap in response) {
      if (type == HistoryTypes.donation) {
        result.add(Donation.fromMap(donationMap));
      }
      if (type == HistoryTypes.allowance) {
        result.add(Allowance.fromMap(donationMap));
      }
    }
    return result;
  }
}
