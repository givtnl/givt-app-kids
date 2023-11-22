import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit(this._tagsRepository) : super(const TagsStateInitial());

  final TagsRepository _tagsRepository;

  void selectLocation({
    required Tag location,
    bool logAmplitude = true,
  }) {
    if (state is TagsStateFetched) {
      if (logAmplitude) {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.locationSelected,
          eventProperties: {
            'location': location.displayText,
            'page_name': Pages.locationSelection.name,
          },
        );
      }

      emit(
        TagsStateFetched(
          tags: state.tags,
          selectedLocation:
              location == (state as TagsStateFetched).selectedLocation
                  ? const Tag.empty()
                  : location,
        ),
      );
    }
  }

  Future<void> fetchTags() async {
    emit(const TagsStateFetching());

    try {
      //PP: shall we remove the event?
      // AnalyticsHelper.logEvent(
      //   eventName: AmplitudeEvent.recommendationFlowStarted,
      // );
      final List<Tag> response = await _tagsRepository.fetchTags();

      emit(TagsStateFetched(tags: response));
    } catch (error) {
      emit(TagsStateError(errorMessage: error.toString()));
    }
  }
}
