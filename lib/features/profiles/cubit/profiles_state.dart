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
      return Profile.empty();
    } else {
      return profiles[activeProfileIndex];
    }
  }

  bool get isOnlyChild {
    if (profiles.isEmpty) return false;
    return profiles.where((element) => element.type.contains('Child')).length ==
        1;
  }
}

class ProfilesInitialState extends ProfilesState {
  const ProfilesInitialState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._noProfileSelected,
  });
}

class ProfilesLoadingState extends ProfilesState {
  /// This is the state that is emitted when the profiles are being fetched for the first time.
  const ProfilesLoadingState({
    super.profiles = const [],
    super.activeProfileIndex = ProfilesState._noProfileSelected,
  });
}

class ProfilesUpdatingState extends ProfilesState {
  /// This is the state that is emitted when the profiles are being updated
  const ProfilesUpdatingState({
    super.profiles = const [],
    required super.activeProfileIndex,
  });
}

class ProfilesUpdatedState extends ProfilesState {
  /// This is the state that is emitted when the profiles are updated
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
