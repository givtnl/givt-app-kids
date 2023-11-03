import 'package:flutter/material.dart';

class AppTheme {
  static const givt4KidsBlue = Color(0xFF54A1EE);
  static const givt4KidsRed = Color(0xFFD53D4C);

  static const logoutButtonColor = Color(0xFFD53D4C);
  static const backButtonColor = Color(0xFFBFDBFC);

  static const defaultTextColor = Color(0xFF3B3240);

  static final historyAllowanceColor =
      const Color(0xFF89BCEF).withAlpha((255 * 0.1).toInt());

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color.fromARGB(255, 62, 73, 112),
    fontFamily: "Raleway",
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: defaultTextColor,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: defaultTextColor,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: defaultTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
