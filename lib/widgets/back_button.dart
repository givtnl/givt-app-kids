// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

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
            AnalyticsHelper.logButtonPressedEvent("back button", "");
            Navigator.of(context).pop();
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
