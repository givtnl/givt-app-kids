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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Vibrator.tryVibrate(duration: Duration(milliseconds: 2500));
  }

  Future<void> _completeDonation() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchProfiles();
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
    } finally {
      if (mounted) {
        Navigator.of(context).popUntil(
          ModalRoute.withName("/"),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List;
    final organisation = args[0] as Organisation;
    final transaction = args[1] as Transaction;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Color(0xFFB9D7FF),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      "assets/lotties/donation.json",
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50,
                      right: 50,
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
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: 50,
                      right: 50,
                      bottom: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_isLoading) {
                          return;
                        }
                        await AnalyticsHelper.logButtonPressedEvent(
                            "Continue", SuccessScreen.routeName);

                        await _completeDonation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF2DF7F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: _isLoading
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Color(0xFF54A1EE),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
