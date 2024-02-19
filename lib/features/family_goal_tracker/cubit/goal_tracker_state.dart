part of 'goal_tracker_cubit.dart';

class GoalTrackerState extends Equatable {
  const GoalTrackerState({
    this.error = '',
    this.currentGoal = const FamilyGoal.empty(),
    this.goals = const [],
  });

  final String error;
  final List<FamilyGoal> goals;
  final FamilyGoal currentGoal;

  @override
  List<Object> get props => [error, goals, currentGoal];

  GoalTrackerState copyWith({
    String? error,
    List<FamilyGoal>? goals,
    FamilyGoal? currentGoal,
  }) {
    return GoalTrackerState(
      error: error ?? this.error,
      goals: goals ?? this.goals,
      currentGoal: currentGoal ?? this.currentGoal,
    );
  }
}
