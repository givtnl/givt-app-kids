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

  Future<void> getGoal(String childId) async {
    try {
      final goals = await _goalTrackerRepository.fetchFamilyGoal();

      // No goals ever set
      if (goals.isEmpty) {
        return;
      }

      // Sort goals by date created, latest first
      goals.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

      // Find the first goal that is not completed
      final current = goals.firstWhere(
        (element) => element.status == FamilyGoalStatus.inProgress,
        orElse: FamilyGoal.empty,
      );

      // There is an active goal
      if (current != const FamilyGoal.empty()) {
        emit(
          state.copyWith(
            currentGoal: current,
            goals: goals,
          ),
        );
        return;
      }

      // No active goals, find the latest completed goal
      final latestCompleted = goals.firstWhere(
        (element) => element.status == FamilyGoalStatus.completed,
        orElse: FamilyGoal.empty,
      );

      if (isGoalDismissed(childId)) {
        // There is a completed goal, but it has been dismissed
        emit(
          state.copyWith(
            currentGoal: const FamilyGoal.empty(),
            goals: goals,
          ),
        );
        return;
      }

      // There is a completed goal, show it in UI
      if (latestCompleted != const FamilyGoal.empty()) {
        emit(
          state.copyWith(
            currentGoal: latestCompleted,
            goals: goals,
          ),
        );
        return;
      }

      // There are no active or completed goals, but goals list is not empty
      // In this case we still show no goal set in UI
      emit(
        state.copyWith(
          error: 'Something went wrong, we cannot find your goal',
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
    if (lastDismissedGoal.mediumId == state.currentGoal.mediumId &&
        lastDismissedGoal.dateCreated == state.currentGoal.dateCreated) {
      return true;
    }
    return false;
  }
}
