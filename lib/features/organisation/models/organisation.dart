import 'package:equatable/equatable.dart';

class Organisation extends Equatable {
  const Organisation({
    required this.organisationId,
    required this.name,
    required this.goal,
    this.logoLink,
    this.thankYou,
  });

  const Organisation.empty()
      : this(
            organisationId: '',
            name: 'Mock Organisation Long Name',
            goal: 'mock goal');

  final String organisationId;
  final String name;
  final String goal;
  final String? logoLink;
  final String? thankYou;

  @override
  List<Object?> get props => [organisationId, name, goal];

  factory Organisation.fromMap(Map<String, dynamic> map) {
    return Organisation(
      organisationId: map['campaignId'] ?? 'no id fetched',
      name: map['title'] ?? 'no name fetched',
      goal: map['goal'] ?? 'no description of goal',
      logoLink: map['logo'],
      thankYou: map['thankYou'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisationId': organisationId,
      'organisationName': name,
      'goal': goal,
    };
  }
}
