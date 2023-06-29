part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  static const int _noProfileSelected = -1;

  const ProfilesState({
    required this.profiles,
    required this.activeProfileIndex,
  });

  final List<Profile> profiles;
  final int activeProfileIndex;

  @override
  List<Object> get props => [profiles, activeProfileIndex];

  bool get isProfileSelected {
    return activeProfileIndex != _noProfileSelected;
  }

  Profile get activeProfile {
    if (activeProfileIndex == _noProfileSelected || profiles.isEmpty) {
      return const Profile.empty();
    } else {
      return profiles[activeProfileIndex];
    }
  }
}

class ProfilesInitialState extends ProfilesState {
  const ProfilesInitialState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._noProfileSelected,
  });
}

class ProfilesLoadingState extends ProfilesState {
  const ProfilesLoadingState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._noProfileSelected,
  });
}

class ProfilesUpdatedState extends ProfilesState {
  const ProfilesUpdatedState({
    required super.profiles,
    required super.activeProfileIndex,
  });
}

class ProfilesExternalErrorState extends ProfilesState {
  const ProfilesExternalErrorState({
    required super.profiles,
    required super.activeProfileIndex,
    this.errorMessage = '',
  });

  final String errorMessage;

  @override
  List<Object> get props => [profiles, activeProfileIndex, errorMessage];
}

class ProfilesCountdownState extends ProfilesUpdatedState {
  const ProfilesCountdownState({
    required super.profiles,
    required super.activeProfileIndex,
    required this.amount,
  });

  final double amount;

  @override
  List<Object> get props => [profiles, activeProfileIndex, amount];
}
