import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v3.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';
import 'package:givt_app_kids/screens/choose_amount_extended_screen.dart';

import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/providers/auth_provider.dart';
import 'package:givt_app_kids/screens/givy_tip_screen.dart';
import 'package:givt_app_kids/screens/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:givt_app_kids/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) {
          return MaterialApp(
            title: 'Givt Kids',
            theme: ThemeData(
                primaryColor: Color.fromARGB(255, 62, 73, 112),
                fontFamily: "Raleway"),
            navigatorObservers: <NavigatorObserver>[observer],
            home: authProvider.isAuthenticated
                ? WalletScreenV3()
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
            },
          );
        },
      ),
    );
  }
}
