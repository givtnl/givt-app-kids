import 'package:equatable/equatable.dart';

class OrganisationDetails extends Equatable {
  const OrganisationDetails({
    required this.collectGroupId,
    required this.name,
    required this.goal,
    this.logoLink,
    this.thankYou,
  });

  const OrganisationDetails.empty()
      : this(
            collectGroupId: '',
            name: 'Mock Organisation Long Name',
            goal: 'mock goal');
  const OrganisationDetails.error()
      : this(
            collectGroupId: '',
            name: 'Something went wrong \n Please try again later',
            goal: 'mock goal');

  final String collectGroupId;
  final String name;
  final String goal;
  final String? logoLink;
  final String? thankYou;

  @override
  List<Object?> get props => [collectGroupId, name, goal];

  factory OrganisationDetails.fromMap(Map<String, dynamic> map) {
    return OrganisationDetails(
      collectGroupId: map['collectGroupId'] ?? 'no id fetched',
      name: map['title'] ?? 'no name fetched',
      goal: map['goal'] ?? 'no description of goal',
      logoLink: map['logo'],
      thankYou: map['thankYou'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisationId': collectGroupId,
      'organisationName': name,
      'goal': goal,
    };
  }
}
