import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('My givts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        TextButton(
            onPressed: () {
              context.pushNamed(Pages.history.name);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.seeDonationHistoryPressed,
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 0)),
            ),
            child: const Text(
              'See all',
              style: TextStyle(
                color: Color(0xFF3B3240),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }
}
