import 'package:givt_app_kids/core/network/api_service.dart';

mixin RecommendRepository {
  Future<bool> sendRecEmail({required String id});
}

class RecomendRepoImpl with RecommendRepository {
  RecomendRepoImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<bool> sendRecEmail({required String id}) async {
    return await _apiService.sendRecEmail(id: id);
  }
}
