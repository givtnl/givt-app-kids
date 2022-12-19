// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/models/goal.dart';

class SuccessScreen extends StatelessWidget {
  static const String routeName = "/success";

  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goal = ModalRoute.of(context)?.settings.arguments as Goal;

    return SafeArea(
      child: Scaffold(
        drawer: SettingsDrawer(),
        body: Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Image(
                  width: 100,
                  image: AssetImage(
                    "assets/images/givy_celebrates.png",
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.only(
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  "Thank you for your gift to",
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  goal.name,
                  style: TextStyle(
                    fontSize: 34,
                    color: Color.fromARGB(255, 244, 191, 99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),

              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                padding: EdgeInsets.only(right: 10, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 217, 217, 217),
                ),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/superman.png"),
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Givy Tip",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Talk to your family why you chose this goal!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
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
              Spacer(),
              Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 25),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName("/wallet"),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    icon: Icon(
                      Icons.house,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "back to start",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
