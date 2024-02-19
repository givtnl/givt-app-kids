import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final goalCubit = context.read<GoalTrackerCubit>();
    final currentGoal = goalCubit.state.currentGoal;
    return Stack(children: [
      Positioned(
        right: 0,
        child: IconButton(
          onPressed: () {
            goalCubit.dismissCompletedGoal(
                context.read<ProfilesCubit>().state.activeProfile.id);
          },
          icon: Icon(
            FontAwesomeIcons.xmark,
            size: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/goal_check.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(currentGoal.orgName,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text('Family Goal: \$${currentGoal.goalAmount}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    ]);
  }
}
