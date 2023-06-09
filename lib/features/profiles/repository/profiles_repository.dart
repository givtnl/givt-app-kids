import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_bff_data_provider.dart';

class ProfilesRepository {
  Future<List<Profile>> fetchProfiles(String parentGuid) async {
    final bffBackend = ProfilesBffDataProvider();
    final response = await bffBackend.fetchProfiles(parentGuid);

    List<Profile> result = [];
    for (final profileMap in response) {
      result.add(Profile.fromMap(profileMap));
    }
    return result;
  }
}
