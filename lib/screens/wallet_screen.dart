// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/goals_list_screen.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = "/wallet";

  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); 

  String _userName = "James";
  int _userAge = 10;
  double _walletAmmount = 20.0;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    var prefs = await StreamingSharedPreferences.instance;
    var name = prefs.getString(SettingsDrawer.nameKey, defaultValue: "James");
    name.listen((newName) {
      setState(() {
        _userName = newName;
      });
    });
    var age = prefs.getInt(SettingsDrawer.ageKey, defaultValue: 11);
    age.listen((newAge) {
      setState(() {
        _userAge = newAge;
      });
    });
    var wallet = prefs.getDouble(SettingsDrawer.walletKey, defaultValue: 20.0);
    wallet.listen((newWalletAmmount) {
      setState(() {
        _walletAmmount = newWalletAmmount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SettingsDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 40),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  15,
                ),
              ),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onLongPress: () => _scaffoldKey.currentState!.openDrawer(),
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 70,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "$_userAge y.o.",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(
                "In my wallet",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 55,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "\$",
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                    TextSpan(text: "$_walletAmmount"),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: _walletAmmount > 0
                  ? () {
                      Navigator.of(context)
                          .pushNamed(GoalsListScreen.routeName);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "I WANT TO GIVE",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
