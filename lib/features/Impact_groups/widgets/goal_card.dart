import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';
import 'package:givt_app_kids/features/impact_groups/widgets/gradient_progress_bar.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({required this.group, super.key});
  final ImpactGroup group;
  @override
  Widget build(BuildContext context) {
    final goal = group.goal;
    final progress = goal.amount / goal.goalAmount.toDouble();
    final totalProgress = goal.totalAmount / goal.goalAmount.toDouble();

    return GestureDetector(
      onTap: () {
        AnalyticsHelper.logEvent(eventName: AmplitudeEvent.goalTrackerTapped);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.highlight99,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.neutralVariant95,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                goal.orgName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              group.type == ImpactGroupType.family
                  ? Text(
                      'Family Goal: \$${goal.goalAmount}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.primary50),
                      textAlign: TextAlign.center,
                    )
                  : Text.rich(
                      TextSpan(
                        text: 'Goal: \$${goal.goalAmount}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.primary50),
                        children: [
                          TextSpan(
                            text: ' · ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.neutralVariant60),
                          ),
                          TextSpan(
                            text: '${group.amountOfMembers} members',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.tertiary50),
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
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
        ),
      ),
    );
  }
}
