import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/repositories/organisation_details_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../organisation_details/models/organisation_details.dart';

part 'organisation_details_state.dart';

class OrganisationDetailsCubit extends Cubit<OrganisationDetailsState> {
  OrganisationDetailsCubit(this._organisationRepository)
      : super(const OrganisationDetailsInitialState());

  final OrganisationDetailsRepository _organisationRepository;

  Future<void> getOrganisationDetails(String qrCode) async {
    try {
      final response =
          await _organisationRepository.fetchOrganosationDetails(qrCode);
      emit(OrganisationDetailsSetState(organisation: response));
    } catch (error) {
      emit(const OrganisationDetailsErrorState());
    }
  }

  void clearOrganisation() {
    emit(const OrganisationDetailsInitialState());
  }
}
