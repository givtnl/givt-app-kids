import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/models/organisation_details.dart';

mixin OrganisationDetailsRepository {
  Future<OrganisationDetails> fetchOrganosationDetails(String mediumId);
}

class OrganisationDetailsRepositoryImpl with OrganisationDetailsRepository {
  OrganisationDetailsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<OrganisationDetails> fetchOrganosationDetails(String mediumId) async {
    final response = await _apiService.fetchOrganisationDetails(mediumId);
    return OrganisationDetails.fromMap(response);
  }
}
