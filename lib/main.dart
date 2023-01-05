import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/screens/wallet_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v2.dart';
import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/goals_list_screen.dart';
import 'package:givt_app_kids/screens/goal_details_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v2.dart';
import 'package:givt_app_kids/screens/home_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v3.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v3.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GoalsProvider(),
      child: MaterialApp(
        title: 'Givt Kids',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 62, 73, 112),
          fontFamily: "Raleway"
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          WalletScreen.routeName: (_) => WalletScreen(),
          WalletScreenV2.routeName: (_) => WalletScreenV2(),
          GoalsListScreen.routeName: (_) => GoalsListScreen(),
          GoalDetailsScreen.routeName: (_) => GoalDetailsScreen(),
          ChooseAmountScreen.routeName: (_) => ChooseAmountScreen(),
          SuccessScreen.routeName: (_) => SuccessScreen(),
          ChooseAmountScreenV2.routeName: (_) => ChooseAmountScreenV2(),
          ChooseAmountScreenV3.routeName: (_) => ChooseAmountScreenV3(),
          HomeScreen.routeName: (_) => HomeScreen(),
          QrCodeScanScreen.routeName: (_) => QrCodeScanScreen(),
          WalletScreenV3.routeName: (_) => WalletScreenV3(),
          ChooseAmountScreenV4.routeName: (_) => ChooseAmountScreenV4(),
        },
      ),
    );
  }
}
