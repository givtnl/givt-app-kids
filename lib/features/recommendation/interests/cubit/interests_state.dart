part of 'interests_cubit.dart';

class InterestsState extends Equatable {
  static const int maxInterests = 3;

  const InterestsState({
    required this.location,
    required this.selectedInterests,
    required this.interests,
  });

  final Tag location;
  final List<Tag> interests;
  final List<Tag> selectedInterests;

  @override
  List<Object> get props => [location, interests, selectedInterests];

  InterestsState copyWith({
    Tag? location,
    List<Tag>? selectedInterests,
    List<Tag>? interests,
  }) {
    return InterestsState(
      location: location ?? this.location,
      interests: interests ?? this.interests,
      selectedInterests: selectedInterests ?? this.selectedInterests,
    );
  }

  static InterestsState empty() {
    return const InterestsState(
      location: Tag.empty(),
      interests: [],
      selectedInterests: [],
    );
  }
}
