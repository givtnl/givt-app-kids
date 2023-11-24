import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const givt4KidsBlue = Color(0xFF54A1EE);
  static const givt4KidsRed = Color(0xFFD53D4C);
  static const givt4KidsYellow = Color(0xFFF2DF7F);
  static const givt4KidsOrange = Color(0xFFE28D4D);

  static const offWhite = Color(0xFFEEEDE4);
  static const backButtonColor = Color(0xFFBFDBFC);
  static const walletBackgroundColor = Color(0xFFF1F7FF);
  static const successBackgroundLightBlue = Color(0xFFB9D7FF);

  static const lightPurple = Color(0xFFF9F6FD);
  static const darkPurpleText = Color(0xFF7957A2);

  static const lightYellow = Color(0xFFFFF7CC);
  static const darkYellowText = Color(0xFF89610F);

  static const defaultTextColor = Color(0xFF3B3240);
  static const darkBlueTextColor = Color(0xFF06509B);
  static const greyButtonColor = Color(0xFFAAAAAA);

  static const woodColor = Color(0xFFD48256);

  static final white85 = Colors.white.withAlpha((255 * 0.85).toInt());

  static const givt4KidsDarkBlue = Color(0xFF2E2957);
  static const givt4KidsDarkGreyBlue = Color(0xFF617793);

  static const givt4KidsLightGreen = Color(0xFF60DD9B);
  static const givt4KidsDarkGreen = Color(0xFF006C47);
  static const givt4KidsRedAlt = Color(0xFFDA2D37);

  static const givyBubbleBackground = Color(0xFFEAEFFD);

  static const recommendationItemSelected = Color(0xFFC7DFBC);
  static const recommendationItemText = Color(0xFF405A66);

  static const actionButtonStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Color(0xFFF1EAE2),
  );
  static final historyAllowanceColor =
      const Color(0xFF89BCEF).withAlpha((255 * 0.1).toInt());

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color.fromARGB(255, 62, 73, 112),
    fontFamily: "Raleway",
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
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
