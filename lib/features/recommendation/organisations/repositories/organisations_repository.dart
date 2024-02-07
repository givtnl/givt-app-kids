import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

mixin OrganisationsRepository {
  Future<List<Organisation>> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    required int pageSize,
    required bool filterInterests,
    required String cityName,
  });
}

class OrganisationsRepositoryImpl with OrganisationsRepository {
  OrganisationsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Organisation>> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    required int pageSize,
    required bool filterInterests,
    required String cityName,
  }) async {
    final response = await _apiService.getRecommendedOrganisations(
      {
        "range": location.key,
        "pageSize": pageSize,
        "tags": interests.map((interest) => interest.key).toList(),
        "city": cityName,
      },
    );

    List<Organisation> result = [];
    for (final organisationMap in response) {
      final organisation = Organisation.fromMap(organisationMap);
      if (filterInterests) {
        organisation.tags.removeWhere((tag) =>
            !interests.contains(tag) && tag.type == TagType.INTERESTS ||
            location.key != tag.key && tag.type == TagType.LOCATION);
      }
      result.add(organisation);
    }
    return result;
  }
}
