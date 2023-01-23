import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v3.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';
import 'package:givt_app_kids/screens/choose_amount_extended_screen.dart';

import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/screens/givy_tip_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Amplitude analytics_amplitude = Amplitude.getInstance();

  @override
  Widget build(BuildContext context) {

  // Init SDK
  analytics_amplitude.init("05353d3a94c0d52d75cc1e7d13faa8e1");


    return MultiProvider(
      providers: [
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
      child: MaterialApp(
        title: 'Givt Kids',
        theme: ThemeData(
            primaryColor: Color.fromARGB(255, 62, 73, 112),
            fontFamily: "Raleway"),
        // navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: WalletScreenV3.routeName,
        routes: {
          // WalletScreen.routeName: (_) => WalletScreen(),
          // WalletScreenV2.routeName: (_) => WalletScreenV2(),
          // GoalsListScreen.routeName: (_) => GoalsListScreen(),
          // GoalDetailsScreen.routeName: (_) => GoalDetailsScreen(),
          // ChooseAmountScreen.routeName: (_) => ChooseAmountScreen(),
          SuccessScreen.routeName: (_) => SuccessScreen(),
          // ChooseAmountScreenV2.routeName: (_) => ChooseAmountScreenV2(),
          // ChooseAmountScreenV3.routeName: (_) => ChooseAmountScreenV3(),
          QrCodeScanScreen.routeName: (_) => QrCodeScanScreen(),
          WalletScreenV3.routeName: (_) => WalletScreenV3(),
          ChooseAmountScreenV4.routeName: (_) => ChooseAmountScreenV4(),
          ChooseAmountExtendedScreen.routeName: (_) =>
              ChooseAmountExtendedScreen(),
          GivyTipScreen.routeName: (_) => GivyTipScreen(),
        },
      ),
    );
  }
}
