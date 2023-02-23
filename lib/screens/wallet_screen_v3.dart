// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
import 'package:givt_app_kids/widgets/transaction_item.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';
import 'package:givt_app_kids/screens/profile_selection_overlay_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    var profilesProvider = Provider.of<ProfilesProvider>(context);

    var recentTransactions = profilesProvider.transactions;
    if (profilesProvider.transactions.length > recentTransactionsNumber) {
      recentTransactions =
          recentTransactions.take(recentTransactionsNumber).toList();
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 238, 235, 207),
        drawer: const SettingsDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          ProfileSelectionOverlayScreen(),
                    ),
                  );

                  AnalyticsHelper.logButtonPressedEvent(
                    "Monster",
                    WalletScreenV3.routeName,
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFD7D6CE),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 25,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SvgPicture.asset(
                          profilesProvider.activeProfile!.monster.image,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 45, right: 45, bottom: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profilesProvider.activeProfile!.name,
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
                          padding:
                              EdgeInsets.only(top: 25, bottom: 25, right: 0),
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
                                            text: profilesProvider
                                                .activeProfile!.balance
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
                            child: SvgPicture.asset(
                                height: 140,
                                fit: BoxFit.fitHeight,
                                "assets/images/wallet.svg"),
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
                        onPressed: profilesProvider.activeProfile!.balance > 0
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
                        icon: SvgPicture.asset("assets/images/qr_icon.svg"),
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
            ],
          ),
        ),
      ),
    );
  }
}
