// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/models/transaction.dart';

class ChooseAmountScreenV4 extends StatefulWidget {
  static const String routeName = "/choose-ammount-v4";

  const ChooseAmountScreenV4({Key? key}) : super(key: key);

  @override
  State<ChooseAmountScreenV4> createState() => _ChooseAmountScreenStateV4();
}

class _ChooseAmountScreenStateV4 extends State<ChooseAmountScreenV4> {
  final List<double> _amountOptions = [2, 5, 7];

  int _currentAmmountIndex = -1;

  double _walletAmmount = 20;
  String _userName = "";

  late final StreamingSharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    _prefs = await StreamingSharedPreferences.instance;
    var wallet = _prefs.getDouble(SettingsDrawer.walletKey, defaultValue: 0.0);
    var name = _prefs.getString(
      SettingsDrawer.nameKey,
      defaultValue: SettingsDrawer.nameDefault,
    );

    setState(() {
      _walletAmmount = wallet.getValue();
      _userName = name.getValue();
    });
  }

  Future<bool> _saveNewTransaction(double amount) async {
    var transaction = Transaction(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      amount: amount,
    );

    var transactionsListPref = _prefs.getStringList(
      SettingsDrawer.transactionsKey,
      defaultValue: [],
    );
    var transactionsList = transactionsListPref.getValue();
    transactionsList.add(jsonEncode(transaction.toJson()));
    return await _prefs.setStringList(
      SettingsDrawer.transactionsKey,
      transactionsList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1EAE2),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF3E7AB5),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 85),
                      Column(
                        children: [
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "\$",
                                  style: TextStyle(
                                    fontSize: 15,
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
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 2,
                  child: Image(
                    height: 75,
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/images/wallet.png"),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 30),
              child: Text(
                "Presbyterian Church Tulsa",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF494C54),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _createPickOptions(),
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: _currentAmmountIndex == -1
                    ? null
                    : () {
                        var giveAmount = _amountOptions[_currentAmmountIndex];
                        var newAmount = _walletAmmount - giveAmount;
                        if (newAmount < 0) {
                          newAmount = 0;
                        }
                        _prefs.setDouble(SettingsDrawer.walletKey, newAmount);

                        _saveNewTransaction(giveAmount);

                        Navigator.of(context).pushNamed(
                          SuccessScreen.routeName,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E7AB5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  child: Text(
                    "Give to this goal",
                    style: TextStyle(
                      fontSize: 26,
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

  List<Widget> _createPickOptions() {
    const double pickItemSize = 65;

    List<Widget> result = [];

    for (var i = 0; i < _amountOptions.length; i++) {
      double currentOptionAmmount;

      bool noMoreMoney = false;
      if (_walletAmmount <= _amountOptions[i]) {
        currentOptionAmmount = _walletAmmount;
        noMoreMoney = true;
      } else {
        currentOptionAmmount = _amountOptions[i];
      }

      result.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if (_currentAmmountIndex == i) {
                _currentAmmountIndex = -1;
              } else {
                _currentAmmountIndex = i;
              }
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: pickItemSize,
            height: pickItemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: i == _currentAmmountIndex
                  ? Color(0xFF3E7AB5)
                  : Color(0xFFCEDDE2),
            ),
            child: Text(
              "\$${currentOptionAmmount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: i == _currentAmmountIndex
                    ? Colors.white
                    : Color(0xFF494C54),
              ),
            ),
          ),
        ),
      );
      if (noMoreMoney) {
        break;
      }
    }

    return result;
  }
}
