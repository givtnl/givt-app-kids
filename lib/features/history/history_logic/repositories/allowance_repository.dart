import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';

mixin AllowanceHistoryRepository {
  Future<List<Allowance>> fetchAllowanceHistory({required String childId});
}

class AllowanceHistoryRepositoryImpl with AllowanceHistoryRepository {
  AllowanceHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Allowance>> fetchAllowanceHistory(
      {required String childId}) async {
    final response =
        await _apiService.fetchHistory(childId, 'RecurringAllowance');

    List<Allowance> result = [];
    for (final donationMap in response) {
      result.add(Allowance.fromMap(donationMap));
    }
    return result;
  }
}
