import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/app_router.dart';
import 'package:givt_app_kids/core/injection/injection.dart';

import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';

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
      ],
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
        return BlocConsumer<ProfilesCubit, ProfilesState>(
            listener: (context, profilesState) {
          if (profilesState is ProfilesUpdatedState) {
            AnalyticsHelper.setUserId(
                profilesState.activeProfile.firstName, profilesState.profiles);
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
    );
  }
}
