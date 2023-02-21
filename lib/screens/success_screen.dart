// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

import 'package:givt_app_kids/screens/givy_tip_screen.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/models/organisation.dart';

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
    _tryVibrate();
  }

  Future<void> _tryVibrate() async {
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate();
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
          color: Color(0xFF54A1EE),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      width: 160,
                      fit: BoxFit.fitWidth,
                      "assets/images/givy_confetti.svg",
                    ),
                  ),
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
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: 50,
                      right: 50,
                      bottom: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        AnalyticsHelper.logButtonPressedEvent(
                            "Continue", SuccessScreen.routeName);

                        Navigator.of(context)
                            .pushNamed(GivyTipScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF2DF7F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 25),
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
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.asset(
                    "assets/lotties/confetti.json",
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
