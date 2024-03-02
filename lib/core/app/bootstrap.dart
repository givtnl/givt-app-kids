import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app_kids/core/app/givt_app.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:givt_app_kids/core/app/firebase_options.dart' as firebase_prod_options;
import 'package:givt_app_kids/core/app/firebase_options_dev.dart' as firebase_dev_options;

import 'package:givt_app_kids/core/injection/injection.dart' as get_it;

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  final givtApp = await builder();

  await LoggingInfo.instance.info('App started');
  await get_it.init((givtApp as GivtApp).config);
  await get_it.getIt.allReady();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async => runApp(givtApp),
    (error, stackTrace) async {
      log(error.toString(), stackTrace: stackTrace);
      await LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
    },
  );
}

/// Returns the firebase options
/// and the current platform
/// based on the current build flavor
Future<(String, FirebaseOptions)> get _firebaseOptions async {
  final info = await PackageInfo.fromPlatform();
  final isDebug = info.packageName.contains('test');

  final name = isDebug ? 'givt4kids-test' : 'givt4kids';
  final options = isDebug
      ? firebase_dev_options.DefaultFirebaseOptions.currentPlatform
      : firebase_prod_options.DefaultFirebaseOptions.currentPlatform;

  return (name, options);
}
