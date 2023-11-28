import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/repositories/organisation_details_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../organisation_details/models/organisation_details.dart';

part 'organisation_details_state.dart';

class OrganisationDetailsCubit extends Cubit<OrganisationDetailsState> {
  OrganisationDetailsCubit(this._organisationRepository)
      : super(const OrganisationDetailsInitialState());

  final OrganisationDetailsRepository _organisationRepository;
  static const String defaultMediumId =
      'NjFmN2VkMDE1NTUzMDEyMmMwMDAuZmMwMDAwMDAwMDAx';

  Future<void> getOrganisationDetails(String mediumId) async {
    emit(const OrganisationDetailsLoadingState());
    mediumId = mediumId.isEmpty ? defaultMediumId : mediumId;

    try {
      final response =
          await _organisationRepository.fetchOrganisationDetails(mediumId);

      emit(OrganisationDetailsSetState(
          organisation: response, mediumId: mediumId));
    } catch (error) {
      emit(OrganisationDetailsErrorState(mediumId: mediumId));
    }
  }
}
