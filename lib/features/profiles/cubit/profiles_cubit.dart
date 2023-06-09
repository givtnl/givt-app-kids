import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit() : super(const ProfilesInitialState()) {
    hydrate();
  }

  Future<void> fetchProfiles(String parentGuid) async {
    emit(ProfilesLoadingState(activeProfile: state.activeProfile));
    final profilesRepository = ProfilesRepository();
    try {
      final response = await profilesRepository.fetchProfiles(parentGuid);
      emit(ProfilesUpdatedState(
        profiles: response,
        activeProfile: state.activeProfile,
      ));
    } catch (error) {
      emit(ProfilesExternalErrorState(
        errorMessage: error.toString(),
        activeProfile: state.activeProfile,
      ));
    }
  }

  void setActiveProfile(Profile profile) {
    emit(ProfilesUpdatedState(
      profiles: state.profiles,
      activeProfile: profile,
    ));
  }

  @override
  ProfilesState? fromJson(Map<String, dynamic> json) {
    log('fromJSON: $json');
    final profilesMap = jsonDecode(json['profiles']);
    final activeProfileMap = jsonDecode(json['activeProfile']);
    Profile activeProfile = Profile.fromMap(activeProfileMap);
    final List<Profile> profiles = [];
    for (final profileMap in profilesMap) {
      profiles.add(Profile.fromMap(profileMap));
    }
    return ProfilesUpdatedState(
      profiles: profiles,
      activeProfile: activeProfile,
    );
  }

  @override
  Map<String, dynamic>? toJson(ProfilesState state) {
    final result = {
      'profiles': jsonEncode(state.profiles),
      'activeProfile': jsonEncode(state.activeProfile.toJson()),
    };
    log('toJSON: $result');
    return result;
  }
}
