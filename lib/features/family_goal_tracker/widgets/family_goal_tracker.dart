import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/goal_active_tracker.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/goal_completed_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocConsumer<GoalTrackerCubit, GoalTrackerState>(
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            SnackBarHelper.showMessage(
              context,
              text: state.error,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.goalTrackerTapped);
            },
            child: _buildGoalWidget(context, state),
          );
        },
      ),
    );
  }

  Widget _buildGoalWidget(BuildContext context, GoalTrackerState state) {
    if (state.currentGoal.status == FamilyGoalStatus.completed) {
      return const GoalCompletedWidget();
    }
    if (state.currentGoal.status == FamilyGoalStatus.inProgress) {
      return const GoalActiveWidget();
    }
    return const SizedBox();
  }
}
