import 'package:flutter/material.dart';
import 'package:givt_app_kids/app_config.dart';
import 'package:givt_app_kids/givt_app.dart';

void main() async {
  
  var configuredApp = AppConfig(
    flavorName: 'production',
    apiBaseUrl: 'api.givt.app',
    amplitudePublicKey: '05353d3a94c0d52d75cc1e7d13faa8e1',
    child: const GivtApp(),
  );

  runApp(configuredApp);
}
