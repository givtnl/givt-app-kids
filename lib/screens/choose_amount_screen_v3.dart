// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givt_app_kids/models/transaction.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/models/goal.dart';
import 'package:givt_app_kids/screens/success_screen.dart';

class ChooseAmountScreenV3 extends StatefulWidget {
  static const String routeName = "/choose-ammount-v3";

  const ChooseAmountScreenV3({Key? key}) : super(key: key);

  @override
  State<ChooseAmountScreenV3> createState() => _ChooseAmountScreenV3State();
}

class _ChooseAmountScreenV3State extends State<ChooseAmountScreenV3> {
  final List<double> _amountOptions = [2, 5, 7];

  int _currentAmmountIndex = -1;

  double _walletAmmount = 20;

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
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 10),
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
                    "In my wallet",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "\$${_walletAmmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 29,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
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
                  Column(
//                    mainAxisAlignment: MainAxisAlignment.,
                    children: _createPickOptions(),
                  ),
                ],
              ),
            ),
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

  List<Widget> _createPickOptions() {
    List<String> pickOptionDesciptionList = [
      "Buys one pack of nails",
      "Buys a savings lamp",
      "Buys a hammer",
    ];

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
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.center,
              width: double.infinity,
              height: pickItemSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
                color: i == _currentAmmountIndex
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "\$${currentOptionAmmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: i == _currentAmmountIndex
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    pickOptionDesciptionList[i],
                    style: TextStyle(
                      fontSize: 24,
                      color: i == _currentAmmountIndex
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              )),
        ),
      );
      if (noMoreMoney) {
        break;
      }
    }

    return result;
  }
}
