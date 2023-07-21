part of 'organisation_cubit.dart';

abstract class OrganisationState extends Equatable {
  const OrganisationState({required this.organisation});
  final Organisation organisation;

  @override
  List<Object> get props => [organisation];
}

class OrganisationInitial extends OrganisationState {
  const OrganisationInitial({super.organisation = const Organisation.empty()});
}

class OrganisationError extends OrganisationState {
  const OrganisationError({
    super.organisation = const Organisation.error(),
  });
}

class OrganisationSet extends OrganisationState {
  const OrganisationSet({required super.organisation});
}
