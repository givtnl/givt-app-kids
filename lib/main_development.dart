import 'package:flutter/material.dart';
import 'package:givt_app_kids/app_config.dart';
import 'package:givt_app_kids/givt_app.dart';

void main() async {
  
  var configuredApp = AppConfig(
    flavorName: 'development',
    apiBaseUrl: 'givt-debug-api.azurewebsites.net',
    amplitudePublicKey: 'e02f6615e27048c072e1058476fce30b',
    child: const GivtApp(),
  );

  runApp(configuredApp);
}