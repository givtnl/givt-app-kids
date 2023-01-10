// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
//import 'package:givt_app_kids/models/goal.dart';
import 'package:givt_app_kids/screens/home_screen.dart';

class SuccessScreen extends StatelessWidget {
  static const String routeName = "/success";

  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final goal = ModalRoute.of(context)?.settings.arguments as Goal;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Color(0xFF3E7AB5),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child:
                        // SvgPicture.asset(
                        //   "assets/images/givy_celebrates.svg",
                        //   width: 120,
                        // )
                        Image(
                      width: 160,
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        "assets/images/givy_celebrates.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 50,
                      right: 50,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 34,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Thank you for your gift to ",
                          ),
                          TextSpan(
                            text: "Presbyterian Church Tulsa",
                            style: TextStyle(
                              color: Color(0xFFE1C075),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        padding: EdgeInsets.only(
                            left: 20, right: 30, top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromARGB(190, 255, 255, 255),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Givy Tip",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF404A70),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Tell your family why\nyou chose this amount!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF404A70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -5,
                        top: -15,
                        child:
                            // SvgPicture.asset(
                            //   "assets/images/givy_superman.svg",
                            //   width: 120,
                            //   height: 100,
                            // ),
                            Image(
                          image: AssetImage("assets/images/givy_superman.png"),
                          width: 120,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 25),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            ModalRoute.withName("/"),
                          );
                          Navigator.of(context).pushNamed(HomeScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        icon: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: SvgPicture.asset(
                            "assets/images/home.svg",
                            width: 25,
                            height: 25,
                            color: Color(0xFF404A70),
                          ),
                        ),
                        label: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Text(
                            "back to start",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF404A70),
                              fontWeight: FontWeight.bold,
                            ),
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
