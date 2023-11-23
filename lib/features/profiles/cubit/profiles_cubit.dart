import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit(this._profilesRepositoy) : super(const ProfilesInitialState()) {
    hydrate();
    AnalyticsHelper.setUserId(state.activeProfile.firstName, state.profiles);
  }

  final ProfilesRepository _profilesRepositoy;

  Future<void> fetchProfiles(String parentGuid) async {
    final activeProfileBalance = state.activeProfile.wallet.balance;
    emit(ProfilesLoadingState(
      profiles: state.profiles,
      activeProfileIndex: state.activeProfileIndex,
    ));
    try {
      final response = await _profilesRepositoy.fetchProfiles(parentGuid);

      var activeProfileNewBalance = state.activeProfileIndex >= 0 &&
              state.activeProfileIndex < response.length
          ? response[state.activeProfileIndex].wallet.balance
          : activeProfileBalance;

      if (activeProfileNewBalance < activeProfileBalance) {
        emit(ProfilesCountdownState(
            profiles: response,
            activeProfileIndex: state.activeProfileIndex,
            amount: activeProfileBalance - activeProfileNewBalance));
      } else {
        emit(ProfilesUpdatedState(
          profiles: response,
          activeProfileIndex: state.activeProfileIndex,
        ));
      }
    } catch (error) {
      emit(ProfilesExternalErrorState(
        errorMessage: error.toString(),
        activeProfileIndex: state.activeProfileIndex,
        profiles: state.profiles,
      ));
    }
  }

  void setActiveProfile(Profile profile) {
    final index = state.profiles.indexOf(profile);
    emit(ProfilesUpdatedState(
      profiles: state.profiles,
      activeProfileIndex: index,
    ));
  }

  void clearProfiles() {
    emit(const ProfilesInitialState());
  }

  @override
  ProfilesState? fromJson(Map<String, dynamic> json) {
    log('fromJSON: $json');
    final profilesMap = jsonDecode(json['profiles']);
    final activeProfileIndex = json['activeProfileIndex'];
    final List<Profile> profiles = [];
    for (final profileMap in profilesMap) {
      profiles.add(Profile.fromMap(profileMap));
    }
    return ProfilesUpdatedState(
      profiles: profiles,
      activeProfileIndex: activeProfileIndex,
    );
  }

  @override
  Map<String, dynamic>? toJson(ProfilesState state) {
    final result = {
      'profiles': jsonEncode(state.profiles),
      'activeProfileIndex': state.activeProfileIndex,
    };
    log('toJSON: $result');
    return result;
  }
}
