// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/widgets/transaction_item.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/providers/auth_provider.dart';

class WalletScreenV3 extends StatefulWidget {
  static const String routeName = "/wallet-v3";

  const WalletScreenV3({Key? key}) : super(key: key);

  @override
  _WalletScreenV3State createState() => _WalletScreenV3State();
}

class _WalletScreenV3State extends State<WalletScreenV3> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final int recentTransactionsNumber = 3;

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.logScreenView(WalletScreenV3.routeName);

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    Future.delayed(
      Duration(seconds: 1),
      (() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.guid,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var walletProvider = Provider.of<WalletProvider>(context);

    var recentTransactions = walletProvider.transactions;
    if (walletProvider.transactions.length > recentTransactionsNumber) {
      recentTransactions =
          recentTransactions.take(recentTransactionsNumber).toList();
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFEEEDE4),
        drawer: const SettingsDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(45),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Provider.of<AccountProvider>(context).name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B3240),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 25, bottom: 25, right: 0),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF54A1EE),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Spacer(flex: 4),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Text(
                                  "My wallet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "\$",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      TextSpan(
                                        text: walletProvider.totalAmount
                                            .toStringAsFixed(2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: GestureDetector(
                        onLongPress: () {
                          AnalyticsHelper.logButtonPressedEvent(
                            "Settings Drawer",
                            WalletScreenV3.routeName,
                          );
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image(
                          height: 140,
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/images/wallet.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: walletProvider.totalAmount > 0
                        ? () {
                            AnalyticsHelper.logButtonPressedEvent(
                              "I want to give",
                              WalletScreenV3.routeName,
                            );

                            Navigator.of(context).pushNamed(
                              QrCodeScanScreen.routeName,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE28D4D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    icon: Image(
                      image: AssetImage("assets/images/qr.png"),
                    ),
                    label: Padding(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                        left: 10,
                      ),
                      child: Text(
                        "I want to give",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF1EAE2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                if (recentTransactions.isNotEmpty)
                  Text(
                    "What I gave recently...",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF3B3240),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: recentTransactions.map((transaction) {
                    return TransactionItem(transaction: transaction);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
