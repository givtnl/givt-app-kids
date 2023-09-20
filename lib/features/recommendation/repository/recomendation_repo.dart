import 'package:givt_app_kids/core/network/api_service.dart';

mixin RecommendationRepository {
  Future<bool> sendRecommendationEmail({required String id});
}

class RecommendationRepositoryImpl with RecommendationRepository {
  RecommendationRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<bool> sendRecommendationEmail({required String id}) async {
    return await _apiService.sendRecommendationEmail(id: id);
  }
}
