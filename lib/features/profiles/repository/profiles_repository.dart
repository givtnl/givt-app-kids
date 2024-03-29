import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';

mixin ProfilesRepository {
  Future<Profile> fetchChildDetails(String childGuid);
  Future<List<Profile>> fetchAllProfiles();
}

class ProfilesRepositoryImpl with ProfilesRepository {
  ProfilesRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Profile>> fetchAllProfiles() async {
    final response = await _apiService.fetchAllProfiles();
    List<Profile> result = [];
    for (final profileMap in response) {
      result.add(Profile.fromMap(profileMap));
    }
    return result;
  }

  @override
  Future<Profile> fetchChildDetails(String childGuid) async {
    final response = await _apiService.fetchChildDetails(childGuid);
    return Profile.fromMap(response);
  }
}
