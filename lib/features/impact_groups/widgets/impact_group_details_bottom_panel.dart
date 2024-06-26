import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:go_router/go_router.dart';

class ImpactGroupDetailsBottomPanel extends StatelessWidget {
  const ImpactGroupDetailsBottomPanel({
    required this.impactGroup,
    super.key,
  });

  final ImpactGroup impactGroup;

  @override
  Widget build(BuildContext context) {
    final activeProfile = context.read<ProfilesCubit>().state.activeProfile;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 16),
      color: AppTheme.highlight99,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Goal${impactGroup.isFamilyGroup ? ': ${impactGroup.goal.orgName}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary30,
                  ),
            ),
            const SizedBox(height: 5),
            GoalProgressBar(
              goal: impactGroup.goal,
              showFlag: true,
              showCurrentLabel: true,
              showGoalLabel: true,
            ),
            const SizedBox(height: 15),
            GivtElevatedButton(
              isDisabled: activeProfile.wallet.balance < 1,
              onTap: () {
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.impactGroupDetailsGiveClicked,
                    eventProperties: {'name': impactGroup.name});

                String generatedMediumId =
                    base64.encode(impactGroup.goal.mediumId.codeUnits);
                context
                    .read<OrganisationDetailsCubit>()
                    .getOrganisationDetails(generatedMediumId);

                context.pushNamed(
                  Pages.chooseAmountSliderGoal.name,
                  extra: impactGroup,
                );
              },
              text: 'Give',
            ),
          ],
        ),
      ),
    );
  }
}
