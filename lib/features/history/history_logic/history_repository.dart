import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
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
