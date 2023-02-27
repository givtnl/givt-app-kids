// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key? key,
    required this.name,
    required this.image,
    this.isLoading = false,
  }) : super(key: key);

  final String name;
  final String image;
  final bool isLoading;

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
                child: SvgPicture.asset(
                  image,
                  width: 100,
                  height: 100,
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
          Positioned.fill(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Color(0xFF54A1EE),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
