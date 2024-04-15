import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/goals/model/goal.dart';
import 'package:givt_app_kids/features/goals/repository/goal_tracker_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'goal_tracker_state.dart';

class GoalTrackerCubit extends Cubit<GoalTrackerState> {
  GoalTrackerCubit(
    this._goalTrackerRepository,
  ) : super(const GoalTrackerState());
  final GoalTrackerRepository _goalTrackerRepository;
  String dissmissedGoalKey(String childId) {
    return '$childId-dissmissedGoalKey';
  }

  bool get hasActiveGoal =>
      state.currentGoal != const Goal.empty() &&
      state.currentGoal.status == GoalStatus.inProgress;

  Future<void> getFamilyGoal(String childId) async {
    emit(
      state.copyWith(
          error: "",
          currentGoal: state.currentGoal.copyWith(
            status: GoalStatus.updating,
          )),
    );
    try {
      final goal = await _goalTrackerRepository.fetchFamilyGoal();

      // No goal
      if (goal == const Goal.empty()) {
        return;
      }
      // Goal is completed and dismissed by this child
      if (goal.status == GoalStatus.completed &&
          isGoalDismissed(childId, goal.goalId)) {
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
          currentGoal: const Goal.empty(),
        ),
      );
    }
  }

  void dismissCompletedGoal(String childId) {
    // remember dismissed goal for future sessions
    getIt<SharedPreferences>()
        .setString(dissmissedGoalKey(childId), state.currentGoal.goalId);
    // dismiss goal from current UI
    emit(
      state.copyWith(
        currentGoal: const Goal.empty(),
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
