import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/goals/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/goals/model/family_goal.dart';
import 'package:givt_app_kids/features/goals/widgets/family_goal_tracker.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoalTrackerCubit, GoalTrackerState>(
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
        return Scaffold(
          body: SafeArea(
            child: state.currentGoal == const FamilyGoal.empty()
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/images/family_superheroes.svg'),
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
      },
    );
  }
}
