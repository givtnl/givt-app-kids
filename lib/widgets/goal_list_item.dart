// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:givt_app_kids/models/goal.dart';
import 'package:givt_app_kids/screens/goal_details_screen.dart';

class GoalListItem extends StatelessWidget {
  const GoalListItem({
    Key? key,
    required this.goal,
  }) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          GoalDetailsScreen.routeName,
          arguments: goal,
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        color: Colors.grey[200],
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          GoalDetailsScreen.routeName,
                          arguments: goal,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        "give",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: SvgPicture.asset(
                      goal.iconAsset,
                      fit: BoxFit.contain,
                      width: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      goal.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // FriendsDonatedList(goal: goal),
            ],
          ),
        ),
      ),
    );
  }
}
