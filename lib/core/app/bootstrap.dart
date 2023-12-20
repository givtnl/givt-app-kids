import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app_kids/core/app/givt_app.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
