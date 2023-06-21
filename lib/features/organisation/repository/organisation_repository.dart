import 'package:givt_app_kids/features/organisation/models/organisation.dart';
import 'package:givt_app_kids/features/organisation/repository/organisation_bff_data_provider.dart';

class OrganisationRepository {
  Future<Organisation> fetchOrganosationDetails(String mediumId) async {
    final bffBackend = OrganisationBffDataProvider();
    final response = await bffBackend.fetchOrganisationDetails(mediumId);
    return response;
  }
}
