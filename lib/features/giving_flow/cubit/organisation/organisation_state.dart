part of 'organisation_cubit.dart';

abstract class OrganisationState extends Equatable {
  const OrganisationState({required this.organisation});
  final Organisation organisation;

  @override
  List<Object> get props => [organisation];
}

class OrganisationInitial extends OrganisationState {
  const OrganisationInitial({
    organisation = const Organisation.empty(),
  }) : super(organisation: organisation);
}

class OrganisationSet extends OrganisationState {
  const OrganisationSet({
    required Organisation organisation,
  }) : super(organisation: organisation);
}
