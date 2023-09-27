import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';

mixin DonationHistoryRepository {
  Future<List<Donation>> fetchHistory(
      {required String childId,
      required int pageNr,
      required HistoryTypes type});
}

class DonationHistoryRepositoryImpl with DonationHistoryRepository {
  DonationHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Donation>> fetchHistory(
      {required String childId,
      required int pageNr,
      required HistoryTypes type}) async {
    final response =
        await _apiService.fetchHistory(childId, type.value, pageNr);

    List<Donation> result = [];
    for (final donationMap in response) {
      result.add(Donation.fromMap(donationMap));
    }
    return result;
  }
}

enum HistoryTypes {
  donation('WalletDonation'),
  allowance('RecurringAllowance');

  final String value;
  const HistoryTypes(this.value);
}
