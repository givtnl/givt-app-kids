part of 'profiles_cubit.dart';

abstract class ProfilesState extends Equatable {
  const ProfilesState({
    required this.profiles,
    required this.activeProfile,
  });

  final List<Profile> profiles;
  final Profile activeProfile;

  @override
  List<Object> get props => [];
}

class ProfilesInitial extends ProfilesState {
  const ProfilesInitial()
      : super(profiles: const [], activeProfile: const Profile.empty());
}
