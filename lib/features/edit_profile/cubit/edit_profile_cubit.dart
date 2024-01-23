import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/edit_profile/models/edit_profile.dart';
import 'package:givt_app_kids/features/edit_profile/repositories/edit_profile_repository.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required this.editProfileRepository,
    required this.childGUID,
    required String currentProfilePicture,
  }) : super(EditProfileState(
          currentProfilePicture: currentProfilePicture,
          selectedProfilePicture: currentProfilePicture,
        ));

  final EditProfileRepository editProfileRepository;
  final String childGUID;

  void selectProfilePicture(String profilePicture) {
    emit(state.copyWith(selectedProfilePicture: profilePicture));
  }

  Future<void> editProfile() async {
    emit(state.copyWith(status: EditProfileStatus.editing));

    try {
      await editProfileRepository.editProfile(
        childGUID: childGUID,
        editProfile: EditProfile(profilePicture: state.selectedProfilePicture),
      );

      emit(state.copyWith(status: EditProfileStatus.edited));
    } catch (e) {
      emit(
        state.copyWith(status: EditProfileStatus.error, error: e.toString()),
      );
    }
  }
}
