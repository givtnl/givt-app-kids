import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app_kids/features/family_goal_tracker/repository/goal_tracker_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'goal_tracker_state.dart';

class GoalTrackerCubit extends Cubit<GoalTrackerState> {
  GoalTrackerCubit(
    this._goalTrackerRepository,
  ) : super(GoalTrackerState(currentGoal: FamilyGoal.empty()));
  final GoalTrackerRepository _goalTrackerRepository;
  String dissmissedGoalKey(String childId) {
    return '$childId-dissmissedGoalKey';
  }

  bool get hasActiveGoal =>
      state.currentGoal != FamilyGoal.empty() &&
      state.currentGoal.status == FamilyGoalStatus.inProgress;

  Future<void> getGoal(String childId) async {
    try {
      final goal = await _goalTrackerRepository.fetchFamilyGoal();

      // No goal
      if (goal == FamilyGoal.empty()) {
        return;
      }
      // Goal is completed and dismissed by this child
      if (goal.status == FamilyGoalStatus.completed &&
          isGoalDismissed(childId, goal.id)) {
        return;
      }

      emit(
        state.copyWith(
          currentGoal: goal,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: "We couldn't fetch your goal\n$e",
        ),
      );
    }
  }

  void dismissCompletedGoal(String childId) {
    // remember dismissed goal for future sessions
    getIt<SharedPreferences>()
        .setString(dissmissedGoalKey(childId), state.currentGoal.id);
    // dismiss goal from current UI
    emit(
      state.copyWith(
        currentGoal: FamilyGoal.empty(),
      ),
    );
  }

  bool isGoalDismissed(String childId, String currentGoalId) {
    final lastDismissedGoalId =
        getIt<SharedPreferences>().getString(dissmissedGoalKey(childId));
    log(lastDismissedGoalId.toString());
    if (lastDismissedGoalId == null) {
      return false;
    }

    if (lastDismissedGoalId == currentGoalId) {
      return true;
    }
    return false;
  }
}
