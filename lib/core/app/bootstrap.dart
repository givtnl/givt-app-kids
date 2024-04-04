import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app_kids/core/app/givt_app.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:givt_app_kids/helpers/remote_config_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:givt_app_kids/core/app/firebase_options.dart'
    as firebase_prod_options;
import 'package:givt_app_kids/core/app/firebase_options_dev.dart'
    as firebase_dev_options;
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:givt_app_kids/core/injection/injection.dart' as get_it;

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final (name, options) = await _firebaseOptions;
  await Firebase.initializeApp(
    name: name,
    options: options,
  );

  // Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  remoteConfig.onConfigUpdated.listen((event) async {
    if (kDebugMode) {
      print('Remote config updated!');
    }
    // Good place to logout users in theory
    // but it is outside all cubits
    await remoteConfig.activate();
  });

  await remoteConfig.setDefaults({
    RemoteConfigFeatures.schoolEventFlow.value: false,
  });

  try {
    await remoteConfig.fetchAndActivate();
  } catch (error, stacktrace) {
    await LoggingInfo.instance.error(
      error.toString(),
      methodName: stacktrace.toString(),
    );
  }

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
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
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
