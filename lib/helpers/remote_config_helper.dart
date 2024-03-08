import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigHelper {
  static bool isFeatureEnabled(RemoteConfigFeatures feature) {
    return FirebaseRemoteConfig.instance.getBool(feature.value);
  }
}

enum RemoteConfigFeatures {
  schoolEventFlow('school_event_flow_enabled'),
  ;

  const RemoteConfigFeatures(this.value);
  final String value;
}
