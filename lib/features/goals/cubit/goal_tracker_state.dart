part of 'goal_tracker_cubit.dart';

class GoalTrackerState extends Equatable {
  const GoalTrackerState({
    this.error = '',
    this.currentGoal = const Goal.empty(),
  });

  final String error;
  final Goal currentGoal;

  @override
  List<Object> get props => [error, currentGoal];

  GoalTrackerState copyWith({
    String? error,
    Goal? currentGoal,
  }) {
    return GoalTrackerState(
      error: error ?? this.error,
      currentGoal: currentGoal ?? this.currentGoal,
    );
  }
}
