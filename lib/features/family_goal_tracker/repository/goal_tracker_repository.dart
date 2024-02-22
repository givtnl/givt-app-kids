import 'package:givt_app_kids/core/network/api_service.dart';
import 'package:givt_app_kids/features/family_goal_tracker/model/family_goal.dart';

mixin GoalTrackerRepository {
  Future<FamilyGoal> fetchFamilyGoal();
}

class GoalTrackerRepositoryImpl with GoalTrackerRepository {
  GoalTrackerRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<FamilyGoal> fetchFamilyGoal() async {
    final response = await _apiService.fetchFamilyGoal();
    if (response == null) {
      return FamilyGoal.empty();
    }

    final FamilyGoal goal = FamilyGoal.fromJson(response);

    return goal;
  }
}
