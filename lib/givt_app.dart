import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'features/giving_flow/cubit/organisation/organisation_cubit.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/api_helper.dart';
import 'app_config.dart';

import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';
import 'package:givt_app_kids/features/auth/screens/login_screen.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app_kids/features/giving_flow/screens/success_screen.dart';

class GivtApp extends StatelessWidget {
  final AppConfig config;
  const GivtApp(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    //Set current env API url
    ApiHelper.apiURL = config.apiBaseUrl;

    //Init Amplitude
    AnalyticsHelper.init(config.amplitudePublicKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
          lazy: false,
        ),
        BlocProvider<ProfilesCubit>(
          create: (BuildContext context) => ProfilesCubit(),
          lazy: true,
        ),
        BlocProvider<OrganisationCubit>(
          create: (BuildContext context) => OrganisationCubit(),
          lazy: true,
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
        return BlocConsumer<ProfilesCubit, ProfilesState>(
            listener: (context, profilesState) {
          if (profilesState is ProfilesUpdatedState) {
            AnalyticsHelper.setUserId(profilesState.activeProfile.firstName);
          }
        }, builder: (context, profilesState) {
          return MaterialApp(
            title: 'Givt Kids',
            theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 62, 73, 112),
                fontFamily: "Raleway"),
            home: authState is LoggedInState
                ? profilesState.isProfileSelected
                    ? const WalletScreenCubit()
                    : const ProfileSelectionScreen()
                : const LoginScreen(),
            routes: {
              CameraScreen.routeName: (_) => const CameraScreen(),
              WalletScreenCubit.routeName: (_) => const WalletScreenCubit(),
              LoginScreen.routeName: (_) => const LoginScreen(),
              ProfileSelectionScreen.routeName: (_) =>
                  const ProfileSelectionScreen(),
              ChooseAmountSliderScreen.routeName: (_) =>
                  const ChooseAmountSliderScreen(),
              SuccessScreen.routeName: (_) => const SuccessScreen(),
            },
          );
        });
      }),
    );
  }
}
