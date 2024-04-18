import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';

mixin ImpactGroupsRepository {
  Future<List<ImpactGroup>> fetchImpactGroups();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<ImpactGroup>> fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    return result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
