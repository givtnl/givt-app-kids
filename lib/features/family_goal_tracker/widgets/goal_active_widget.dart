import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/gradient_progress_bar.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class GoalActiveWidget extends StatelessWidget {
  const GoalActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<GoalTrackerCubit>().state;
    final currentGoal = state.currentGoal;
    final progress = currentGoal.amount / currentGoal.goal.toDouble();
    final totalProgress = currentGoal.totalAmount / currentGoal.goal.toDouble();
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 56, top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentGoal.collectGroupName,
              style: Theme.of(context).textTheme.titleSmall),
          Text('Family Goal: \$${currentGoal.goal}',
              style: Theme.of(context).textTheme.bodySmall),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: GradientProgressBar(
              progress: progress > 1 ? 1 : progress,
              totalProgress: totalProgress > 1 ? 1 : totalProgress,
              colors: const [
                AppTheme.highlight90,
                AppTheme.progressGradient1,
                AppTheme.progressGradient2,
                AppTheme.progressGradient3,
                AppTheme.primary70,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
