import 'dart:convert';
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
  ) : super(const GoalTrackerState());
  final GoalTrackerRepository _goalTrackerRepository;
  String dissmissedGoalKey(String childId) {
    return '$childId-dissmissedGoalKey';
  }

  bool get hasActiveGoal =>
      state.currentGoal != const FamilyGoal.empty() &&
      state.currentGoal.status == FamilyGoalStatus.inProgress;

  Future<void> getGoal(String childId) async {
    try {
      final goal = await _goalTrackerRepository.fetchFamilyGoal();

      // No goal
      if (goal == const FamilyGoal.empty()) {
        return;
      }
      // Goal is completed and dismissed by this child
      if (goal.status == FamilyGoalStatus.completed &&
          isGoalDismissed(childId)) {
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
    // dismiss goal from current UI
    emit(
      state.copyWith(
        currentGoal: const FamilyGoal.empty(),
      ),
    );
    // remember dismissed goal for future sessions
    getIt<SharedPreferences>()
        .setString(dissmissedGoalKey(childId), state.currentGoal.toJson());
  }

  bool isGoalDismissed(String childId) {
    final lastDismissedGoalString =
        getIt<SharedPreferences>().getString(dissmissedGoalKey(childId));
    if (lastDismissedGoalString == null) {
      return false;
    }
    final lastDismissedGoal = FamilyGoal.fromMap(
        jsonDecode(lastDismissedGoalString) as Map<String, dynamic>);

    if (lastDismissedGoal.goalId == state.currentGoal.goalId) {
      return true;
    }
    return false;
  }
}
