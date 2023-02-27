// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/models/organisation.dart';
import 'package:givt_app_kids/helpers/vibrator.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';

class SuccessScreen extends StatefulWidget {
  static const String routeName = "/success";

  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Vibrator.tryVibratePattern();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List;
    final organisation = args[0] as Organisation;
    final transaction = args[1] as Transaction;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB9D7FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 40,
                  left: 40,
                  right: 40,
                ),
                child: Text(
                  "You gave \$${transaction.amount.toStringAsFixed(2)} to ${organisation.name}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Lottie.asset(
                "assets/lotties/donation.json",
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 25),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).popUntil(
                  ModalRoute.withName("/"),
                );
                await AnalyticsHelper.logButtonPressedEvent(
                    "Continue", SuccessScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF2DF7F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF3B3240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
