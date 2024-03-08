import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class RemoteConfigHelper {
  static bool isFeatureEnabled(RemoteConfigFeatures feature) {
    return FirebaseRemoteConfig.instance.getBool(feature.value);
  }

  static bool logoutHelper(BuildContext context) {
    final isSchoolEventFlowEnabled = RemoteConfigHelper.isFeatureEnabled(
        RemoteConfigFeatures.schoolEventFlow);
    final auth = context.read<AuthCubit>().state as LoggedInState;

    if (!isSchoolEventFlowEnabled && auth.isSchoolEvenMode) {
      context.read<AuthCubit>().logout();
      context.read<ProfilesCubit>().clearProfiles();
      context.read<FlowsCubit>().resetFlow();
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvent.schoolEventLogOutTriggered,
      );
      return true;
    }
    return false;
  }
}

enum RemoteConfigFeatures {
  schoolEventFlow('school_event_flow_enabled'),
  ;

  const RemoteConfigFeatures(this.value);
  final String value;
}
