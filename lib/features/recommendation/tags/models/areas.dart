import 'package:flutter/material.dart';

enum Areas {
  environment(color: Color(0xFF00845A)),
  health(color: Color(0xFF7AAA35)),
  education(color: Color(0xFF54A1EE)),
  basic(color: Color(0xFFFAB63E)),
  disaster(color: Color(0xFFF99370)),
  location(color: Color(0xFF285C92)),
  ;

  final Color color;

  const Areas({
    required this.color,
  });

  factory Areas.fromMap(Map<String, dynamic> map) {
    try {
      return Areas.values.byName(
        (map['area'] ?? '').toLowerCase(),
      );
    } on ArgumentError {
      return Areas.location;
    }
  }
}
