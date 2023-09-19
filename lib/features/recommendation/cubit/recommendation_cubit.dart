import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/recommendation/repository/recomendation_repo.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit(this._recRepositoy) : super(RecommendationInitial());
  final RecommendRepository _recRepositoy;

  void askMyParents(String kidId) async {
    try {
      final response = await _recRepositoy.sendRecEmail(id: kidId);
      if (response) {
        emit(RecommendationSent());
      } else {
        emit(RecommendationSendFailed());
      }
      emit(RecommendationSent());
    } catch (e) {
      emit(RecommendationSendFailed());
    }
  }
}
