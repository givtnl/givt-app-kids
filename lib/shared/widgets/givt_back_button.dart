import 'package:flutter/material.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class GivtBackButton extends StatelessWidget {
  const GivtBackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Opacity(
        opacity: context.canPop() ? 1 : 0,
        child: AbsorbPointer(
          absorbing: !context.canPop(),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.backButtonColor,
            child: IconButton(
              iconSize: 25,
              onPressed: () {
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.backButtonPressed);

                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.givt4KidsBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
