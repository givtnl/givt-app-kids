import 'package:flutter/material.dart';

import 'package:givt_app_kids/models/goal.dart';

class GoalsProvider with ChangeNotifier {
  final List<Goal> _goals = [
    Goal(
      name: "Animal Shelter",
      description: "Help the local animal shelter to extend their dog kennel.",
      what:
          "We take care of animals who no longer have a home.",
      who: "Animals like dogs, cats and rabbits without a home.",
      how: "We will build another dog kennel to house 10 more dogs.",
      friendsNum: 3,
      iconAsset: "assets/images/dog.svg",
      bgAsset: "assets/images/shelter.jpg",
    ),
    Goal(
      name: "Operation Christmas Child",
      description: "Deliver gifts for children in need on Christmas.",
      what:
          "Deliver gifts for children in need on Christmas.",
      who: "Kids in need all around the world.",
      how: "Make gift-filled shoeboxes. Each box packed full of toys, school supplies, and personal care items.",
      friendsNum: 4,
      iconAsset: "assets/images/child.svg",
      bgAsset: "assets/images/xmas.jpg",
    ),
  ];

  List<Goal> get goals {
    return [..._goals];
  }

  Goal get qrCodeFlowGoal {
    return Goal(
      name: "Reconstruct Presbyterian Church Tulsa",
      description: "We are going to reconstruct the Presbyterian Church Tulsa building.",
      what:
          "We reconstruct the Presbyterian Church Tulsa building.",
      who: "We're building a great new place to celebrate together.",
      how: "You donation will go towards reconstructing the church.",
      friendsNum: 0,
      iconAsset: "assets/images/church.svg",
      bgAsset: "assets/images/reconstruction.jpg",
    );

  }
}
