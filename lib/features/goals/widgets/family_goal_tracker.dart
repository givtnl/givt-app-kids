import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/goals/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/goals/model/goal.dart';
import 'package:givt_app_kids/features/goals/widgets/goal_active_widget.dart';
import 'package:givt_app_kids/features/goals/widgets/goal_completed_widget.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.highlight99,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.neutralVariant95,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.goalTrackerTapped);

              if (state.currentGoal.isActive) {
                String generatedMediumId =
                    base64.encode(state.currentGoal.mediumId.codeUnits);
                context
                    .read<OrganisationDetailsCubit>()
                    .getOrganisationDetails(generatedMediumId);

                context.read<FlowsCubit>().startFamilyGoalFlow();

                context.pushNamed(
                  Pages.chooseAmountSliderGoal.name,
                  extra: state.currentGoal,
                );
              }
            },
            child: _buildGoalWidget(context, state),
          );
        },
      ),
    );
  }

  Widget _buildGoalWidget(BuildContext context, GoalTrackerState state) {
    switch (state.currentGoal.status) {
      case GoalStatus.completed:
        return const GoalCompletedWidget();
      case GoalStatus.inProgress:
      case GoalStatus.updating:
        return const GoalActiveWidget();
      default:
        return const SizedBox();
    }
  }
}
