// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class BackButton extends StatelessWidget {
  const BackButton({this.icon, super.key});
  final Widget? icon;
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

            context.pop();
          },
          icon: icon ??
              Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF54A1EE),
              ),
        ),
      ),
    );
  }
}
