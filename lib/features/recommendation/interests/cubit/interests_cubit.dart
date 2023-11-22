import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

part 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  InterestsCubit({
    required this.location,
    required this.interests,
  }) : super(
          InterestsState(
            location: location,
            interests: interests,
            selectedInterests: const [],
          ),
        );
  final Tag location;
  final List<Tag> interests;

  void selectInterest(Tag interest) {
    final newSelectedInterests = [...state.selectedInterests];
    if (newSelectedInterests.contains(interest)) {
      newSelectedInterests.remove(interest);
    } else if (newSelectedInterests.length < InterestsState.maxInterests) {
      newSelectedInterests.add(interest);
    }

    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvent.interestSelected,
      eventProperties: {
        'interest_name': interest.displayText,
        'selected_interests':
            newSelectedInterests.map((e) => e.displayText).toList().toString(),
        'page_name': Pages.interestsSelection.name,
      },
    );

    emit(state.copyWith(selectedInterests: newSelectedInterests));
  }

  void clearSelectedInterests() {
    emit(state.copyWith(selectedInterests: []));
  }
}
