import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app_kids/features/recommendation/organisations/repositories/organisations_repository.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

part 'organisations_state.dart';

class OrganisationsCubit extends Cubit<OrganisationsState> {
  OrganisationsCubit(this._organisationsRepository)
      : super(const OrganisationsInitialState());

  final OrganisationsRepository _organisationsRepository;

  Future<void> getRecommendedOrganisations({
    required Tag location,
    required List<Tag> interests,
    Duration fakeComputingExtraDelay = Duration.zero,
  }) async {
    emit(const OrganisationsFetchingState());

    await Future.delayed(fakeComputingExtraDelay);

    try {
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvent.nextToCharitiesPressed,
        eventProperties: {
          'interests': '${interests.map((e) => e.displayText).toList()}',
          'page_name': Pages.interestsSelection.name,
        },
      );
      final response =
          await _organisationsRepository.getRecommendedOrganisations(
        location: location,
        interests: interests,
      );

      emit(OrganisationsFetchedState(organisations: response));
    } catch (error) {
      emit(OrganisationsExternalErrorState(errorMessage: error.toString()));
    }
  }
}
