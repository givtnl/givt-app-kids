// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  // headers: {},
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF3B3240),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
