// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/providers/auth_provider.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final TextEditingController _nameTextController = TextEditingController();

  String _appVersion = "None";

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    var userName = Provider.of<AccountProvider>(context, listen: false).name;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _nameTextController.text = userName;
      _appVersion = "${packageInfo.version}(${packageInfo.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
//    var walletProvider = Provider.of<WalletProvider>(context);
//    var accountProvider = Provider.of<AccountProvider>(context);
    var profilesProvider = Provider.of<ProfilesProvider>(context);

    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Settings v$_appVersion",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 2,
              ),
              SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: Card(
              //     color: Colors.grey[200],
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           SizedBox(
              //             width: double.infinity,
              //             child: Text(
              //               "Account",
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //           TextField(
              //             controller: _nameTextController,
              //             decoration: InputDecoration(hintText: "Name"),
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold, fontSize: 22),
              //             onChanged: (value) {
              //               accountProvider.setName(value);
              //             },
              //           ),
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.max,
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: [
              //               IconButton(
              //                 onPressed: () {
              //                   if (accountProvider.age > 0) {
              //                     accountProvider
              //                         .setAge(accountProvider.age - 1);
              //                   }
              //                 },
              //                 icon: Icon(Icons.remove_circle_outline),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.all(5),
              //                 child: Text(
              //                   "${accountProvider.age} y.o.",
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 20,
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 onPressed: () {
              //                   accountProvider.setAge(accountProvider.age + 1);
              //                 },
              //                 icon: Icon(Icons.add_circle_outline_outlined),
              //               ),
              //             ],
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.max,
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: [
              //               IconButton(
              //                 onPressed: walletProvider.totalAmount >= 0
              //                     ? () {
              //                         var newAmount =
              //                             walletProvider.totalAmount -
              //                                 _changeWalletAmmountStep;
              //                         if (newAmount < 0) {
              //                           newAmount = 0;
              //                         }
              //                         walletProvider.setAmount(newAmount);
              //                       }
              //                     : null,
              //                 icon: Icon(Icons.remove_circle_outline),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.all(5),
              //                 child: Text(
              //                   "\$${walletProvider.totalAmount.toStringAsFixed(2)}",
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 20,
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 onPressed: () {
              //                   walletProvider.setAmount(
              //                       walletProvider.totalAmount +
              //                           _changeWalletAmmountStep);
              //                 },
              //                 icon: Icon(Icons.add_circle_outline_outlined),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure you want to logout?"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              AnalyticsHelper.logEvent(
                                                  eventName: AmplitudeEvent
                                                      .drawerLongPressed);
                                              return Navigator.of(context)
                                                  .pop(true);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("CANCEL"),
                                            onPressed: () {
                                              return Navigator.of(context)
                                                  .pop(false);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  ).then((value) {
                                    if (value) {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .logout();
                                      Provider.of<ProfilesProvider>(context,
                                              listen: false)
                                          .clearProfiles();
                                    }
                                  });
                                },
                                icon: Icon(Icons.logout),
                                label: Text(
                                  "Logout",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
