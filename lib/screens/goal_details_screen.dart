// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:givt_app_kids/models/goal.dart';
import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/widgets/friends_donated_list.dart';
import 'package:givt_app_kids/screens/choose_amount_screen.dart';

class GoalDetailsScreen extends StatelessWidget {
  static const String routeName = "/goal-details";

  const GoalDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goal = ModalRoute.of(context)?.settings.arguments as Goal;

    return Scaffold(
      drawer: SettingsDrawer(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(goal.bgAsset),
              ),
            ),
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          goal.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white, // Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        goal.icon,
                        size: 65,
                        color: Colors.white, // Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  FriendsDonatedList(goal: goal),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    createDescriptionCard(context, "What we do", goal.what),
                    createDescriptionCard(context, "Who we help", goal.who),
                    createDescriptionCard(
                        context, "How we use your giving", goal.how),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ChooseAmountScreen.routeName,
                  arguments: goal,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "GIVE TO THIS GOAL",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createDescriptionCard(
    BuildContext context,
    String title,
    String description,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.grey[200],
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
