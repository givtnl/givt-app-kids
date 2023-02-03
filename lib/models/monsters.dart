import 'package:flutter/material.dart';

enum Monsters {
  purple(image: "assets/images/monster1.svg", color: Color(0xFFAD81E1)),
  blue(image: "assets/images/monster2.svg", color: Color(0xFF69A9D3)),
  orange(image: "assets/images/monster3.svg", color: Color(0xFFFEAD1D)),
  green(image: "assets/images/monster4.svg", color: Color(0xFFA7CB42)),
  ;

  const Monsters({
    required this.image,
    required this.color,
  });

  final String image;
  final Color color;
}
