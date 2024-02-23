part of 'goal_tracker_cubit.dart';

class GoalTrackerState extends Equatable {
  const GoalTrackerState({
    this.error = '',
    this.currentGoal = const FamilyGoal.empty(),
  });

  final String error;
  final FamilyGoal currentGoal;

  @override
  List<Object> get props => [error, currentGoal];

  GoalTrackerState copyWith({
    String? error,
    FamilyGoal? currentGoal,
  }) {
    return GoalTrackerState(
      error: error ?? this.error,
      currentGoal: currentGoal ?? this.currentGoal,
    );
  }
}
