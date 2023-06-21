import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/organisation/repository/organisation_repository.dart';

import '../models/organisation.dart';

part 'organisation_state.dart';

class OrganisationCubit extends Cubit<OrganisationState> {
  OrganisationCubit() : super(OrganisationInitial());

  Future<void> getOrganisationDetails(String qrCode) async {
    await Future.delayed(const Duration(seconds: 2));
    final organisationRepository = OrganisationRepository();
    try {
      final response =
          await organisationRepository.fetchOrganosationDetails(qrCode);
      emit(OrganisationSet(organisation: response));
    } catch (error) {
      // TODO: implement error handling
    }
  }
}
