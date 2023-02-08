import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
