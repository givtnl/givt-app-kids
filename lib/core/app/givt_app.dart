import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/app_router.dart';
import 'package:givt_app_kids/core/injection/injection.dart';

import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'app_config.dart';

class GivtApp extends StatelessWidget {
  final AppConfig config;
  const GivtApp(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    //Init Amplitude
    AnalyticsHelper.init(config.amplitudePublicKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(
            getIt(),
          ),
          lazy: false,
        ),
        BlocProvider<ProfilesCubit>(
          create: (BuildContext context) => ProfilesCubit(getIt()),
          lazy: true,
        ),
        BlocProvider<OrganisationDetailsCubit>(
          create: (BuildContext context) => OrganisationDetailsCubit(getIt()),
          lazy: true,
        ),
        BlocProvider<FlowsCubit>(
          create: (BuildContext context) => FlowsCubit(),
        ),
        BlocProvider<GoalTrackerCubit>(
          create: (BuildContext context) => GoalTrackerCubit(getIt()),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => ScanNfcCubit(),
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
        return BlocConsumer<ProfilesCubit, ProfilesState>(
            listener: (context, profilesState) {
          if (profilesState is ProfilesUpdatedState) {
            AnalyticsHelper.setUserId(profilesState.activeProfile.firstName);
          }
        }, builder: (context, profilesState) {
          return const _AppView();
        });
      }),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();
  @override
  Widget build(BuildContext context) {
    const theme = AppTheme();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.toThemeData(),
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
    );
  }
}
