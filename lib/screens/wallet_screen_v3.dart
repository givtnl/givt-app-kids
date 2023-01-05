// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';

class WalletScreenV3 extends StatefulWidget {
  static const String routeName = "/wallet-v3";

  const WalletScreenV3({Key? key}) : super(key: key);

  @override
  _WalletScreenV3State createState() => _WalletScreenV3State();
}

class _WalletScreenV3State extends State<WalletScreenV3> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _userName = SettingsDrawer.nameDefault;
  int _userAge = SettingsDrawer.ageDefault;
  double _walletAmmount = SettingsDrawer.walletAmountDefault;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    var prefs = await StreamingSharedPreferences.instance;

    if (!mounted) return;

    var name = prefs.getString(
      SettingsDrawer.nameKey,
      defaultValue: SettingsDrawer.nameDefault,
    );
    name.listen((newName) {
      if (!mounted) return;
      setState(() {
        _userName = newName;
      });
    });
    var age = prefs.getInt(
      SettingsDrawer.ageKey,
      defaultValue: SettingsDrawer.ageDefault,
    );
    age.listen((newAge) {
      if (!mounted) return;
      setState(() {
        _userAge = newAge;
      });
    });
    var wallet = prefs.getDouble(
      SettingsDrawer.walletKey,
      defaultValue: SettingsDrawer.walletAmountDefault,
    );
    wallet.listen((newWalletAmmount) {
      if (!mounted) return;
      setState(() {
        _walletAmmount = newWalletAmmount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF1EAE2),
        drawer: const SettingsDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _scaffoldKey.currentState!.openDrawer(),
                child: Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF404A70),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E7AB5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        Expanded(
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
                                      text: _walletAmmount.toStringAsFixed(2),
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
                    child: Image(
                      height: 140,
                      fit: BoxFit.fitHeight,
                      image: AssetImage("assets/images/wallet.png"),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _walletAmmount > 0
                      ? () {
                          Navigator.of(context).pushNamed(
                            QrCodeScanScreen.routeName,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7EBC89),
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
            ],
          ),
        ),
      ),
    );
  }
}
