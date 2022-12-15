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
              SizedBox(
                height: 150,
              ),
              Padding(
                padding: EdgeInsets.only(left: 60),
                child: Icon(
                  Icons.cloud_done_rounded,
                  size: 60,
                  color: Colors.white, // Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 50,
              ),
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
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 217, 217, 217),
                ),
                child: Row(
                  children: [
                    Image(
                      width: 70,
                      height: 70,
                      image: AssetImage(
                        "assets/images/superman.png",
                      ),
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
              // SizedBox(
              //   height: 30,
              // ),
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
