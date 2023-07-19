import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/injection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit() : super(const ProfilesInitialState()) {
    hydrate();
    AnalyticsHelper.setUserId(state.activeProfile.firstName);
  }
  final prefs = getIt<SharedPreferences>();

  Future<void> fetchProfiles(String parentGuid, bool? updateLocal) async {
    final activeProfileBalance = state.activeProfile.wallet.balance;
    emit(ProfilesLoadingState(
      profiles: state.profiles,
      activeProfileIndex: state.activeProfileIndex,
    ));
    final profilesRepository = ProfilesRepository();
    try {
      final response = await profilesRepository.fetchProfiles(parentGuid);

      if (updateLocal == true) {
        updateLocalPending(response[state.activeProfileIndex].wallet.pending);
      }

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

  void updateLocalPending(double newPending) {
    final currentProfileId = state.profiles[state.activeProfileIndex].id;
    prefs.setDouble("$currentProfileId-pending", newPending);
  }

  double getPendingDifference() {
    final lastPending = prefs
        .getDouble("${state.profiles[state.activeProfileIndex].id}-pending");
    final currentPending =
        state.profiles[state.activeProfileIndex].wallet.pending;
    final currentProfileId = state.profiles[state.activeProfileIndex].id;

    if (lastPending == null) {
      prefs.setDouble("$currentProfileId-pending", currentPending);
      return 0;
    }
    final difference = lastPending - currentPending;
    prefs.setDouble("$currentProfileId-pending", currentPending);
    return difference;
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
