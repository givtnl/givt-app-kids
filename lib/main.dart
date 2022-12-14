import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/screens/wallet_screen.dart';
import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/screens/goals_list_screen.dart';
import 'package:givt_app_kids/screens/goal_details_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen.dart';
import 'package:givt_app_kids/screens/success_screen.dart';

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
        ),
        initialRoute: WalletScreen.routeName,
        routes: {
          WalletScreen.routeName: (_) => WalletScreen(),
          GoalsListScreen.routeName: (_) => GoalsListScreen(),
          GoalDetailsScreen.routeName: (_) => GoalDetailsScreen(),
          ChooseAmountScreen.routeName: (_) => ChooseAmountScreen(),
          SuccessScreen.routeName: (_) => SuccessScreen(),
        },
      ),
    );
  }
}
