import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'package:flutter/services.dart';

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    this.primaryColor = const Color(0xFF006D42),
    this.secondaryColor = const Color(0xFF00696A),
    this.tertiaryColor = const Color(0xFF744AA5),
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

//Colors of the tiles of wallet screen
  static const highlight98 = Color(0xFFFFF9EB);
  static const highlight80 = Color(0xFFDCC74D);
  static const highlight40 = Color(0xFF6C5E00);
  static const disabledTileBackground = Color(0xFFF5F4F5);
  static const disabledTileBorder = Color(0xFFC8C6C9);

//colors of tiles in the give bottomsheet
  static const lightPurple = Color(0xFFF9F6FD);
  static const darkPurpleText = Color(0xFF7957A2);
  static const lightYellow = Color(0xFFFFF7CC);
  static const darkYellowText = Color(0xFF89610F);

//for recommendation flow
  static const recommendationItemSelected = Color(0xFFC7DFBC);
  static const recommendationItemText = Color(0xFF405A66);
  static const interestsTallyText = Color(0xFFFBFCFF);
  static const interestCardRadio = Color(0xFF7AAA35);

//functionally used on screen
  static const givt4KidsBlue = Color(0xFF54A1EE);
  static const offWhite = Color(0xFFEEEDE4);
  static const backButtonColor = Color(0xFFBFDBFC);
  static const successBackgroundLightBlue = Color(0xFFB9D7FF);
  static const defaultTextColor = Color(0xFF3B3240);
  static const givyBubbleBackground = Color(0xFFEAEFFD);
  static final historyAllowanceColor =
      const Color(0xFF89BCEF).withAlpha((255 * 0.1).toInt());

  Scheme _schemeLight() {
    final base = CorePalette.of(primaryColor.value);
    final primary = base.primary;
    final secondary = CorePalette.of(secondaryColor.value).primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
    return Scheme(
      primary: primary.get(50),
      onPrimary: primary.get(99),
      primaryContainer: primary.get(80),
      onPrimaryContainer: primary.get(30),
      secondary: secondary.get(40),
      onSecondary: secondary.get(98),
      secondaryContainer: secondary.get(90),
      onSecondaryContainer: secondary.get(10),
      tertiary: tertiary.get(40),
      onTertiary: tertiary.get(98),
      tertiaryContainer: tertiary.get(90),
      onTertiaryContainer: tertiary.get(10),
      error: base.error.get(40),
      onError: base.error.get(100),
      errorContainer: base.error.get(90),
      onErrorContainer: base.error.get(10),
      background: base.neutral.get(100),
      onBackground: primary.get(10),
      surface: base.neutral.get(99),
      onSurface: base.neutral.get(10),
      outline: base.neutralVariant.get(50),
      outlineVariant: base.neutralVariant.get(80),
      surfaceVariant: base.neutralVariant.get(90),
      onSurfaceVariant: base.neutralVariant.get(30),
      shadow: tertiary.get(0),
      scrim: tertiary.get(0),
      inverseSurface: tertiary.get(20),
      inverseOnSurface: secondary.get(80),
      inversePrimary: primary.get(40),
    );
  }

  ThemeData _base(final ColorScheme colorScheme) {
    final textTheme = TextTheme(
      titleLarge: TextStyle(
        color: colorScheme.onPrimaryContainer,
        fontSize: 26,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.primary,
        fontSize: 28,
      ),
      labelSmall: TextStyle(
        color: colorScheme.onPrimaryContainer,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        color: colorScheme.onPrimaryContainer,
        fontSize: 20,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Rouna",
      textTheme: textTheme,
      primaryColor: colorScheme.primary,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      extensions: [this],
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardTheme(color: colorScheme.surfaceVariant),
    );
  }

  ThemeData toThemeData() {
    final colorScheme = _schemeLight().toColorScheme(Brightness.light);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) =>
      AppTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      );

  @override
  AppTheme lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    if (other is! AppTheme) return this;
    return AppTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
    );
  }
}

extension on Scheme {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      primary: Color(primary),
      onPrimary: Color(onPrimary),
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
      secondary: Color(secondary),
      onSecondary: Color(onSecondary),
      secondaryContainer: Color(secondaryContainer),
      onSecondaryContainer: Color(onSecondaryContainer),
      tertiary: Color(tertiary),
      onTertiary: Color(onTertiary),
      tertiaryContainer: Color(tertiaryContainer),
      onTertiaryContainer: Color(onTertiaryContainer),
      error: Color(error),
      onError: Color(onError),
      errorContainer: Color(errorContainer),
      onErrorContainer: Color(onErrorContainer),
      outline: Color(outline),
      outlineVariant: Color(outlineVariant),
      background: Color(background),
      onBackground: Color(onBackground),
      surface: Color(surface),
      onSurface: Color(onSurface),
      surfaceVariant: Color(surfaceVariant),
      onSurfaceVariant: Color(onSurfaceVariant),
      inverseSurface: Color(inverseSurface),
      onInverseSurface: Color(inverseOnSurface),
      inversePrimary: Color(inversePrimary),
      shadow: Color(shadow),
      scrim: Color(scrim),
      surfaceTint: Color(primary),
      brightness: brightness,
    );
  }
}
