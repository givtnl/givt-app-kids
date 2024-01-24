import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit(this._profilesRepositoy) : super(const ProfilesInitialState()) {
    hydrate();
    AnalyticsHelper.setUserId(state.activeProfile.firstName);
  }

  final ProfilesRepository _profilesRepositoy;

  Future<void> fetchAllProfiles() async {
    emit(ProfilesLoadingState(
      profiles: state.profiles,
      activeProfileIndex: state.activeProfileIndex,
    ));
    try {
      final List<Profile> newProfiles = [];
      final response = await _profilesRepositoy.fetchAllProfiles();
      newProfiles.addAll(response);

      for (var oldProfile in state.profiles) {
        Profile? newProfile = response.firstWhere(
          (element) => element.id == oldProfile.id,
          orElse: () => Profile.empty(),
        );
        if (newProfile == Profile.empty()) {
          final updatedProfile = oldProfile.copyWith(
            firstName: newProfile.firstName,
            lastName: newProfile.lastName,
            pictureURL: newProfile.pictureURL,
          );
          newProfiles[state.profiles.indexOf(oldProfile)] = updatedProfile;
        }
      }
      // The countdown state does not work, let's please fix it in a separate ticket.

      // final activeProfileBalance = state.activeProfile.wallet.balance;
      // var activeProfileNewBalance = state.activeProfileIndex >= 0 &&
      //         state.activeProfileIndex < response.length
      //     ? newProfiles[state.activeProfileIndex].wallet.balance
      //     : activeProfileBalance;

      // if (activeProfileNewBalance < activeProfileBalance) {
      //   emit(ProfilesCountdownState(
      //       profiles: newProfiles,
      //       activeProfileIndex: state.activeProfileIndex,
      //       amount: activeProfileBalance - activeProfileNewBalance));
      // }
      emit(ProfilesUpdatedState(
        profiles: newProfiles,
        activeProfileIndex: state.activeProfileIndex,
      ));
    } catch (error, stackTrace) {
      LoggingInfo.instance.error('Error while fetching profiles: $error',
          methodName: stackTrace.toString());
      emit(ProfilesExternalErrorState(
        errorMessage: error.toString(),
        activeProfileIndex: state.activeProfileIndex,
        profiles: state.profiles,
      ));
    }
  }

  Future<void> fetchActiveProfile(String id) async {
    final profile = state.profiles.firstWhere((element) => element.id == id);
    final index = state.profiles.indexOf(profile);
    final childGuid = state.profiles[index].id;
    emit(ProfilesLoadingState(
      profiles: state.profiles,
      activeProfileIndex: index,
    ));
    try {
      final response = await _profilesRepositoy.fetchChildDetails(childGuid);
      state.profiles[index] = response;
      emit(ProfilesUpdatedState(
        profiles: state.profiles,
        activeProfileIndex: index,
      ));
    } catch (error, stackTrace) {
      LoggingInfo.instance.error('Error while fetching profiles: $error',
          methodName: stackTrace.toString());
      emit(ProfilesExternalErrorState(
        errorMessage: error.toString(),
        activeProfileIndex: state.activeProfileIndex,
        profiles: state.profiles,
      ));
    }
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
