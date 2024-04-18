import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/impact_groups/model/goal.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';

mixin ImpactGroupsRepository {
  Future<Goal> fetchFamilyGoal();
  Future<List<ImpactGroup>> fetchImpactGroups();
}

class ImpactGroupsRepositoryImpl with ImpactGroupsRepository {
  ImpactGroupsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<Goal> fetchFamilyGoal() async {
    final response = await _apiService.fetchFamilyGoal();
    if (response == null) {
      return const Goal.empty();
    }

    final Goal goal = Goal.fromMap(response);

    return goal;
  }

  @override
  Future<List<ImpactGroup>> fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    return result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
