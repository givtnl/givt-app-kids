part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  const ProfilesState({
    required this.profiles,
    required this.activeProfile,
  });

  final List<Profile> profiles;
  final Profile activeProfile;

  @override
  List<Object> get props => [profiles, activeProfile];

  bool get isProfileSelected {
    return activeProfile != const Profile.empty();
  }
}

class ProfilesInitialState extends ProfilesState {
  const ProfilesInitialState(
      {super.profiles = const [], super.activeProfile = const Profile.empty()});
}

class ProfilesLoadingState extends ProfilesState {
  const ProfilesLoadingState(
      {super.profiles = const [], super.activeProfile = const Profile.empty()});
}

class ProfilesUpdatedState extends ProfilesState {
  const ProfilesUpdatedState(
      {required super.profiles, required super.activeProfile});
}

class ProfilesExternalErrorState extends ProfilesState {
  const ProfilesExternalErrorState(
      {super.profiles = const [],
      super.activeProfile = const Profile.empty(),
      this.errorMessage = ''});

  final String errorMessage;

  @override
  List<Object> get props => [profiles, activeProfile, errorMessage];
}
