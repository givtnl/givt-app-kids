// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = "/wallet";

  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  String _userName = "James";
  int _userAge = 10;
  final double walletAmmount = 20.0;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  void _readPreferences() async {
    var prefs = await StreamingSharedPreferences.instance;
    var name = prefs.getString(SettingsDrawer.nameKey, defaultValue: "");
    name.listen((newName) {
      setState(() {
        _userName = newName;
      });
    });
    var age = prefs.getInt(SettingsDrawer.ageKey, defaultValue: 0);
    age.listen((newAge) {
      setState(() {
        _userAge = newAge;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  15,
                ),
              ),
            ),
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
                    TextSpan(text: "$walletAmmount"),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "I WANT TO DONATE",
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
