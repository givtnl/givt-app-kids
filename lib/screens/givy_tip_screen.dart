// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:givt_app_kids/screens/wallet_screen_v3.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class GivyTipScreen extends StatefulWidget {
  static const String routeName = "/givy-tip";

  const GivyTipScreen({Key? key}) : super(key: key);

  @override
  State<GivyTipScreen> createState() => _GivyTipScreenState();
}

class _GivyTipScreenState extends State<GivyTipScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsHelper.logScreenView(GivyTipScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF2DF7F),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                // Spacer(
                //   flex: 2,
                // ),
                LayoutBuilder(builder: (ctx, constraints) {
                  return SvgPicture.asset(
                    "assets/images/givy_tip.svg",
                    width: (constraints.maxWidth * 0.9),
                    fit: BoxFit.fitWidth,
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Givy Tip",
                  style: TextStyle(
                    color: Color(0xFF494C54),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Talk to your family about how it felt to give to something important",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF494C54),
//                  fontWeight: FontWeight.bold,
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

//                Spacer(),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      AnalyticsHelper.logButtonPressedEvent(
                          "Continue", GivyTipScreen.routeName);
                      Navigator.of(context).popUntil(
                        ModalRoute.withName("/"),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF54A1EE),
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
