import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app_kids/features/impact_groups/model/goal.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/models/organisation_details.dart';
import 'package:givt_app_kids/features/impact_groups/model/impact_group.dart';

class FamilyGoalWidget extends StatelessWidget {
  final OrganisationDetails organisation;
  final Goal goal;

  const FamilyGoalWidget(this.goal, this.organisation, {super.key});

  @override
  Widget build(BuildContext context) {
    final impactGroupsState = context.watch<ImpactGroupsCubit>().state;
    final group = impactGroupsState.getGoalGroup(goal);
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Row(
        children: [
          if (organisation.logoLink != null)
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.only(right: 12),
              child: Image.network(
                organisation.logoLink!,
                fit: BoxFit.contain,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.orgName,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  group.type == ImpactGroupType.family
                      ? 'Family goal: \$${goal.goalAmount}'
                      : 'Goal: \$${goal.goalAmount}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
