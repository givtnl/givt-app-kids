import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/profiles/models/donation.dart';

mixin DonationHistoryRepository {
  Future<List<Donation>> fetchDonationHistory(
      {required String childId, required int pageNr});
}

class DonationHistoryRepositoryImpl with DonationHistoryRepository {
  DonationHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Donation>> fetchDonationHistory(
      {required String childId, required int pageNr}) async {
    final response =
        await _apiService.fetchHistory(childId, 'WalletDonation', pageNr);

    List<Donation> result = [];
    for (final donationMap in response) {
      result.add(Donation.fromMap(donationMap));
    }
    return result;
  }
}
