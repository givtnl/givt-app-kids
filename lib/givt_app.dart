import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart'
    as camera_bloc;
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart'
    as wallet_bloc;
import 'package:givt_app_kids/features/auth/screens/login_screen.dart'
    as login_bloc;
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/api_helper.dart';
import 'package:provider/provider.dart';

import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/providers/auth_provider.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';

import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart'
    as profiles_bloc;

import 'package:givt_app_kids/features/giving_flow/screens/choose_amount_slider_screen.dart'
    as create_transaction_bloc;

import 'package:givt_app_kids/features/giving_flow/screens/success_screen.dart'
    as create_transaction_bloc;

import 'app_config.dart';
import 'features/giving_flow/cubit/organisation/organisation_cubit.dart';

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
          lazy: false,
        ),
        BlocProvider<OrganisationCubit>(
          create: (BuildContext context) => OrganisationCubit(),
          lazy: true,
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProfilesProvider>(
            create: (_) => ProfilesProvider("", []),
            update: (ctx, authProvider, oldProvider) => ProfilesProvider(
              authProvider.accessToken,
              oldProvider != null ? oldProvider.profiles : [],
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => GoalsProvider(),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => WalletProvider(),
          // ),
          ChangeNotifierProvider(
            create: (_) => AccountProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, authProvider, _) {
            return Consumer<ProfilesProvider>(
              builder: (ctx, profilesProvider, _) {
                return MaterialApp(
                  title: 'Givt Kids',
                  theme: ThemeData(
                      primaryColor: Color.fromARGB(255, 62, 73, 112),
                      fontFamily: "Raleway"),
                  home: authProvider.isAuthenticated
                      ? profilesProvider.isProfileSelected
                          ? wallet_bloc.WalletScreenCubit()
                          : profiles_bloc.ProfileSelectionScreen()
                      : login_bloc.LoginScreen(),
                  routes: {
                    camera_bloc.CameraScreen.routeName: (_) =>
                        camera_bloc.CameraScreen(),
                    wallet_bloc.WalletScreenCubit.routeName: (_) =>
                        wallet_bloc.WalletScreenCubit(),
                    login_bloc.LoginScreen.routeName: (_) =>
                        login_bloc.LoginScreen(),
                    profiles_bloc.ProfileSelectionScreen.routeName: (_) =>
                        profiles_bloc.ProfileSelectionScreen(),
                    create_transaction_bloc.ChooseAmountSliderScreen.routeName:
                        (_) =>
                            create_transaction_bloc.ChooseAmountSliderScreen(),
                    create_transaction_bloc.SuccessScreen.routeName: (_) =>
                        create_transaction_bloc.SuccessScreen(),
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
