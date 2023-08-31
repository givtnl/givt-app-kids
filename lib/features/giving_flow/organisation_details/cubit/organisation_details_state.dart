part of 'organisation_details_cubit.dart';

abstract class OrganisationDetailsState extends Equatable {
  const OrganisationDetailsState({required this.organisation});
  final OrganisationDetails organisation;

  @override
  List<Object> get props => [organisation];
}

class OrganisationDetailsInitialState extends OrganisationDetailsState {
  const OrganisationDetailsInitialState(
      {super.organisation = const OrganisationDetails.empty()});
}

class OrganisationDetailsErrorState extends OrganisationDetailsState {
  const OrganisationDetailsErrorState({
    super.organisation = const OrganisationDetails.error(),
  });
}

class OrganisationDetailsSetState extends OrganisationDetailsState {
  const OrganisationDetailsSetState({required super.organisation});
}
