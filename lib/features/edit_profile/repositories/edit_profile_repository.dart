import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/edit_profile/models/edit_profile.dart';

mixin EditProfileRepository {
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  });
}

class EditProfileRepositoryImpl with EditProfileRepository {
  EditProfileRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  }) async {
    await _apiService.editProfile(childGUID, editProfile.toJson());
  }
}
