import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/goals/model/group_organiser.dart';

class ImpactGroup extends Equatable {
  const ImpactGroup({
    required this.id,
    required this.status,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.amountOfMembers,
    required this.organiser,
  });

  const ImpactGroup.empty()
      : this(
          id: '',
          status: ImpactGroupStatus.unknown,
          type: ImpactGroupType.unknown,
          name: '',
          description: '',
          image: '',
          amountOfMembers: 0,
          organiser: const GroupOrganiser.empty(),
        );

  factory ImpactGroup.fromMap(Map<String, dynamic> map) {
    return ImpactGroup(
      id: map['id'] as String,
      status: ImpactGroupStatus.fromString(map['status'] as String),
      type: ImpactGroupType.fromString(map['type'] as String),
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      amountOfMembers: (map['amountOfMembers'] as num).toInt(),
      organiser:
          GroupOrganiser.fromMap(map['organiser'] as Map<String, dynamic>),
    );
  }

  final String id;
  final ImpactGroupStatus status;
  final ImpactGroupType type;
  final String name;
  final String description;
  final String image;
  final int amountOfMembers;
  final GroupOrganiser organiser;

  @override
  List<Object?> get props => [
        id,
        status,
        type,
        name,
        description,
        image,
        amountOfMembers,
        organiser,
      ];

  ImpactGroup copyWith({
    String? id,
  }) {
    return ImpactGroup(
      id: id ?? this.id,
      status: status,
      type: type,
      name: name,
      description: description,
      image: image,
      amountOfMembers: amountOfMembers,
      organiser: organiser,
    );
  }
}

enum ImpactGroupStatus {
  invited('Invited'),
  accepted('Accepted'),
  unknown('Unknown');

  const ImpactGroupStatus(this.value);

  final String value;

  static ImpactGroupStatus fromString(String value) {
    return ImpactGroupStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => ImpactGroupStatus.unknown,
    );
  }
}

enum ImpactGroupType {
  family('Family'),
  general('General'),
  unknown('Unknown');

  const ImpactGroupType(this.value);

  final String value;

  static ImpactGroupType fromString(String value) {
    return ImpactGroupType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => ImpactGroupType.unknown,
    );
  }
}
