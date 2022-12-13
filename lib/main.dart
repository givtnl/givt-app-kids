import 'package:flutter/material.dart';

import 'package:givt_app_kids/screens/wallet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Givt App Kids',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 62, 73, 112),
        ),
        initialRoute: WalletScreen.routeName,
        routes: {
          WalletScreen.routeName: (_) => WalletScreen(),
        });
  }
}
