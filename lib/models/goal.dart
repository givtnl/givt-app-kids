import 'package:flutter/material.dart';

class Goal {
  final String name;
  final String description;
  final String what;
  final String who;
  final String how;
  final int friendsNum;
  final IconData icon;
  final String bgAsset;

  Goal({
    required this.name,
    required this.description,
    required this.what,
    required this.who,
    required this.how,
    required this.friendsNum,
    required this.icon,
    required this.bgAsset,
  });
}
