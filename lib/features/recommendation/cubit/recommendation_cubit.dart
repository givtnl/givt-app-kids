import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/recommendation/repository/recomendation_repo.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit(this._recRepositoy) : super(RecommendationInitial());
  final RecommendationRepository _recRepositoy;

  void askMyParents(String childId) async {
    emit(RecommendationSending());
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvent.askToFindCharityPressed,
    );
    try {
      final response = await _recRepositoy.sendRecommendationEmail(id: childId);
      if (response) {
        emit(RecommendationSent());
      } else {
        emit(RecommendationSendFailed());
      }
    } catch (e) {
      emit(RecommendationSendFailed());
    }
  }
}
