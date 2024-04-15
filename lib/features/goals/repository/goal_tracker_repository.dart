import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/goals/model/goal.dart';

mixin GoalTrackerRepository {
  Future<Goal> fetchFamilyGoal();
}

class GoalTrackerRepositoryImpl with GoalTrackerRepository {
  GoalTrackerRepositoryImpl(
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
}
