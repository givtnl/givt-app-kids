import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/remote_config_helper.dart';

class SchoolEventHelper {
  static bool logoutSchoolEventUsers(BuildContext context) {
    final isSchoolEventFlowEnabled = RemoteConfigHelper.isFeatureEnabled(
        RemoteConfigFeatures.schoolEventFlow);

    if (!isSchoolEventFlowEnabled && isSchoolEventUser(context)) {
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

  static bool isSchoolEventUser(BuildContext context) {
    final auth = context.read<AuthCubit>().state;

    if (auth is LoggedInState && auth.isSchoolEvenMode) {
      return true;
    }
    return false;
  }
}
