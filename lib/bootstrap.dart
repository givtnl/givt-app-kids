import 'dart:async';
import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Init SDK
  final analytics_amplitude = Amplitude.getInstance();
  analytics_amplitude.init("05353d3a94c0d52d75cc1e7d13faa8e1");
  analytics_amplitude.trackingSessionEvents(true);
  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
