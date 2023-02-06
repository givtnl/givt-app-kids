import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    required this.flavorName,
    required this.apiBaseUrl,
    required this.amplitudePublicKey,
    required Widget child,
  }) : super(child: child);

  final String flavorName;
  final String apiBaseUrl;
  final String amplitudePublicKey;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
