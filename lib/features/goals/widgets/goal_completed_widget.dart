import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/features/goals/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/datetime_extension.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final goalCubit = context.read<GoalTrackerCubit>();
    final currentGoal = goalCubit.state.currentGoal;
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {
              goalCubit.dismissCompletedGoal(
                  context.read<ProfilesCubit>().state.activeProfile.id);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.goalDismissed,
                eventProperties: {
                  AnalyticsHelper.goalKey: currentGoal.orgName,
                  AnalyticsHelper.amountKey: currentGoal.goalAmount.toString(),
                  AnalyticsHelper.dateEUKey:
                      DateTime.parse((currentGoal.dateCreated))
                          .formattedFullEuDate,
                },
              );
            },
            icon: Icon(
              FontAwesomeIcons.xmark,
              size: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/goal_check.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: double.infinity,
                height: 4,
              ),
              Text(
                currentGoal.orgName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Family Goal completed. Great job!',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
