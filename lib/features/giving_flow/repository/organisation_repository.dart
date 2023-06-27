import 'package:givt_app_kids/features/giving_flow/models/organisation.dart';
import 'package:givt_app_kids/features/giving_flow/repository/data_providers/organisation_bff_data_provider.dart';

class OrganisationRepository {
  Future<Organisation> fetchOrganosationDetails(String mediumId) async {
    final bffBackend = OrganisationBffDataProvider();
    final response = await bffBackend.fetchOrganisationDetails(mediumId);
    return response;
  }
}
