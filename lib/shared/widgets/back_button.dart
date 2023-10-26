// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFFBFDBFC),
        child: IconButton(
          iconSize: 25,
          onPressed: () {
            AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.backButtonPressed);

            context.canPop()
                ? context.pop()
                : context.goNamed(Pages.splash.name);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF54A1EE),
          ),
        ),
      ),
    );
  }
}