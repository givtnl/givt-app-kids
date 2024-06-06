import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/income.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/features/history/models/history_item.dart';

mixin HistoryRepository {
  Future<List<HistoryItem>> fetchHistory(
      {required String childId,
      required int pageNumber,
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
      required int pageNumber,
      required HistoryTypes type}) async {
    final Map<String, dynamic> body = {
      'pageNumber': pageNumber,
      'pageSize': 10,
      'type': type.value
    };
    final response = await _apiService.fetchHistory(childId, body);

    List<HistoryItem> result = [];

    for (final donationMap in response) {
      if (donationMap['donationType'] == HistoryTypes.donation.value) {
        result.add(Donation.fromMap(donationMap));
      }
      if (donationMap['donationType'] == HistoryTypes.allowance.value ||
          donationMap['donationType'] == HistoryTypes.topUp.value) {
        result.add(Income.fromMap(donationMap));
      }
    }
    return result;
  }
}
