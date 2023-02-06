import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/api_helper.dart';
import 'package:provider/provider.dart';

import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v3.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';
import 'package:givt_app_kids/screens/choose_amount_extended_screen.dart';

import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/providers/auth_provider.dart';
import 'package:givt_app_kids/screens/givy_tip_screen.dart';
import 'package:givt_app_kids/screens/login_screen.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';
import 'package:givt_app_kids/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/screens/profile_selection_overlay_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_slider_screen.dart';

import 'app_config.dart';

class GivtApp extends StatelessWidget {
  const GivtApp({super.key});

  @override
  Widget build(BuildContext context) {
    setEnvContext(context);
    initAmplitude(context);

    return MultiProvider(
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
                        ? WalletScreenV3()
                        : ProfileSelectionScreen()
                    : LoginScreen(),
                routes: {
                  SuccessScreen.routeName: (_) => SuccessScreen(),
                  QrCodeScanScreen.routeName: (_) => QrCodeScanScreen(),
                  WalletScreenV3.routeName: (_) => WalletScreenV3(),
                  ChooseAmountScreenV4.routeName: (_) => ChooseAmountScreenV4(),
                  ChooseAmountExtendedScreen.routeName: (_) =>
                      ChooseAmountExtendedScreen(),
                  GivyTipScreen.routeName: (_) => GivyTipScreen(),
                  LoginScreen.routeName: (_) => LoginScreen(),
                  ProfileSelectionScreen.routeName: (_) =>
                      ProfileSelectionScreen(),
                  ProfileSelectionOverlayScreen.routeName: (_) =>
                      ProfileSelectionOverlayScreen(),
                  ChooseAmountSliderScreen.routeName: (_) =>
                      ChooseAmountSliderScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }

  void initAmplitude(BuildContext context) {
    final config = AppConfig.of(context)!;
    final analyticsAmplitude = Amplitude.getInstance();

    analyticsAmplitude.init(config.amplitudePublicKey);
    analyticsAmplitude.trackingSessionEvents(true);
  }

  void setEnvContext(BuildContext context) {
    final config = AppConfig.of(context)!; 

    ApiHelper.apiURL = config.apiBaseUrl;
  }
}