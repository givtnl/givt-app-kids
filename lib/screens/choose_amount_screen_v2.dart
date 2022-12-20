// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/models/goal.dart';
import 'package:givt_app_kids/screens/success_screen.dart';

class ChooseAmountScreenV2 extends StatefulWidget {
  static const String routeName = "/choose-ammount-v2";

  const ChooseAmountScreenV2({Key? key}) : super(key: key);

  @override
  _ChooseAmountScreenV2State createState() => _ChooseAmountScreenV2State();
}

class _ChooseAmountScreenV2State extends State<ChooseAmountScreenV2> {
  double _walletAmmount = 20;
  double _selectedAmount = 0;

  late final StreamingSharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    _prefs = await StreamingSharedPreferences.instance;
    var wallet = _prefs.getDouble(SettingsDrawer.walletKey, defaultValue: 0.0);
    setState(() {
      _walletAmmount = wallet.getValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = ModalRoute.of(context)?.settings.arguments as Goal;

    return SafeArea(
      child: Scaffold(
        drawer: SettingsDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Text(
                goal.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Choose amount you want to give",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "\$${_selectedAmount.round()}",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                "\$0",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$${_walletAmmount.round()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Slider(
                          value: _selectedAmount,
                          min: 0,
                          max: _walletAmmount,
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Theme.of(context).primaryColor.withAlpha(38), //15%
                          divisions: _walletAmmount.round(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAmount = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: _selectedAmount == 0
                    ? null
                    : () {
                        var newAmount = _walletAmmount - _selectedAmount;
                        if (newAmount < 0) {
                          newAmount = 0;
                        }
                        _prefs.setDouble(SettingsDrawer.walletKey, newAmount);

                        Navigator.of(context).pushNamed(
                          SuccessScreen.routeName,
                          arguments: goal,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "GIVE NOW",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
