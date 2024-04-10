import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/family_goal_tracker.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalState = context.watch<GoalTrackerCubit>().state;
    return Scaffold(
      body: SafeArea(
        child: goalState.currentGoal == const FamilyGoal.empty()
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/family_superheroes.svg'),
                    const SizedBox(height: 20),
                    Text(
                      'Your Family Group and other\ngroups will appear here',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : const FamilyGoalTracker(),
      ),
    );
  }
}
