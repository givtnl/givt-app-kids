import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/goals/model/goal.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/models/organisation_details.dart';

class FamilyGoalWidget extends StatelessWidget {
  final OrganisationDetails organisation;
  final Goal familyGoal;

  const FamilyGoalWidget(this.familyGoal, this.organisation, {super.key});

  @override
  Widget build(BuildContext context) {
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
                Text(familyGoal.orgName,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  'Family goal: \$${familyGoal.goalAmount}',
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
