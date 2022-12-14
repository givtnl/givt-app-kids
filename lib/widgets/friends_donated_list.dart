// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:givt_app_kids/models/goal.dart';

class FriendsDonatedList extends StatelessWidget {
  static const double friendIconOffset = 20;

  const FriendsDonatedList({Key? key, required this.goal}) : super(key: key);

  final Goal goal;

  Widget _createFriendsStack(BuildContext context, int friendsNum) {
    var iconSize = 44.0;

    List<Widget> iconsList = [];
    for (var i = 0; i < friendsNum; i++) {
      iconsList.add(
        Positioned(
          left: i * friendIconOffset,
          child: CircleAvatar(
            radius: iconSize / 2,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.face,
              size: iconSize,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }
    return Container(
      width: iconSize + ((iconSize / 2) * (friendsNum - 1)),
      height: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: iconsList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _createFriendsStack(context, goal.friendsNum),
        SizedBox(
          width: 5,
        ),
        Text(
          "${goal.friendsNum} friends donated to\nthis goal",
          maxLines: 2,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            
            fontWeight: FontWeight.bold,
            color: Colors.white,// Colors.black,
          ),
        ),
      ],
    );
  }
}
