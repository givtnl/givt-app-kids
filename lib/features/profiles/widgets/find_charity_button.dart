import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class FindCharityButton extends StatelessWidget {
  const FindCharityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(Pages.locationSelection.name);
        AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.helpMeFindCharityPressed);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: const Text(
        'Help me find a charity',
        style: TextStyle(
          color: Color(0xFF3B3240),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
