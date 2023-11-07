import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const givt4KidsBlue = Color(0xFF54A1EE);
  static const givt4KidsRed = Color(0xFFD53D4C);
  static const givt4KidsYellow = Color(0xFFF2DF7F);

  static const logoutButtonColor = Color(0xFFD53D4C);
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
