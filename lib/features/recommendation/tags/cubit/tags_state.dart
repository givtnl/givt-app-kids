part of 'tags_cubit.dart';

abstract class TagsState extends Equatable {
  const TagsState({
    required this.tags,
  });

  final List<Tag> tags;

  List<Tag> get locations {
    return tags.where((element) => element.type == TagType.LOCATION).toList();
  }

  List<Tag> get interests {
    return tags.where((element) => element.type == TagType.INTERESTS).toList();
  }

  Tag get selectedLocation {
    return const Tag.empty();
  }

  @override
  List<Object> get props => [tags];
}

class TagsStateInitial extends TagsState {
  const TagsStateInitial() : super(tags: const []);
}

class TagsStateFetching extends TagsState {
  const TagsStateFetching() : super(tags: const []);
}

class TagsStateFetched extends TagsState {
  const TagsStateFetched({
    required super.tags,
    Tag selectedLocation = const Tag.empty(),
  }) : _selectedLocation = selectedLocation;

  @override
  Tag get selectedLocation => _selectedLocation;

  final Tag _selectedLocation;

  @override
  List<Object> get props => [tags, selectedLocation];
}

class TagsStateError extends TagsState {
  const TagsStateError({
    required this.errorMessage,
  }) : super(tags: const []);

  final String errorMessage;

  @override
  List<Object> get props => [tags, errorMessage];
}
