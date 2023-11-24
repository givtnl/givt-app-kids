import 'package:flutter/material.dart';

import 'package:givt_app_kids/features/recommendation/interests/cubit/interests_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class InterestsTally extends StatelessWidget {
  const InterestsTally({
    required this.tally,
    super.key,
  });

  final int tally;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.givt4KidsBlue,
      ),
      child: Text(
        '$tally/${InterestsState.maxInterests}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.interestsTallyText,
              fontFamily: 'RadioCanada',
            ),
      ),
    );
  }
}
