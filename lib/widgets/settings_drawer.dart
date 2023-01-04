// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';

import 'package:givt_app_kids/models/transaction.dart';

class SettingsDrawer extends StatefulWidget {
  static const String nameKey = "nameKey";
  static const String ageKey = "ageKey";
  static const String walletKey = "walletKey";
  static const String transactionsKey = "transactionsKey";

  static const String nameDefault = "James";
  static const int ageDefault = 11;
  static const double walletAmountDefault = 20.0;

  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final TextEditingController _nameTextController = TextEditingController();

  late final StreamingSharedPreferences _prefs;

  final double _changeWalletAmmountStep = 5;

  String _userName = "James";
  int _userAge = 10;
  double _walletAmmount = 20.0;

  String _appVersion = "None";

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    _prefs = await StreamingSharedPreferences.instance;
    var name = _prefs.getString(SettingsDrawer.nameKey, defaultValue: "");
    var age = _prefs.getInt(SettingsDrawer.ageKey, defaultValue: 0);
    var walletAmmount =
        _prefs.getDouble(SettingsDrawer.walletKey, defaultValue: 0.0);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _userName = name.getValue();
      _nameTextController.text = _userName;
      _userAge = age.getValue();
      _walletAmmount = walletAmmount.getValue();
      _appVersion = packageInfo.version;
    });
  }

  void _setName(String newName) {
    _prefs.setString(SettingsDrawer.nameKey, newName);
    setState(() {
      _userName = newName;
    });
  }

  void _setAge(int newAge) {
    _prefs.setInt(SettingsDrawer.ageKey, newAge);
    setState(() {
      _userAge = newAge;
    });
  }

  void _setWalletAmmount(double newAmmount) {
    _prefs.setDouble(SettingsDrawer.walletKey, newAmmount);
    setState(() {
      _walletAmmount = newAmmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    var transactionsListPref = _prefs.getStringList(
      SettingsDrawer.transactionsKey,
      defaultValue: [],
    );
    var transactionsList = transactionsListPref.getValue();

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
                        TextField(
                          controller: _nameTextController,
                          decoration: InputDecoration(hintText: "Name"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          onChanged: (value) {
                            _setName(value);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_userAge > 0) {
                                  _setAge(_userAge - 1);
                                }
                              },
                              icon: Icon(Icons.remove_circle_outline),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "$_userAge y.o.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _setAge(_userAge + 1);
                              },
                              icon: Icon(Icons.add_circle_outline_outlined),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_walletAmmount - _changeWalletAmmountStep >=
                                    0) {
                                  _setWalletAmmount(_walletAmmount -
                                      _changeWalletAmmountStep);
                                }
                              },
                              icon: Icon(Icons.remove_circle_outline),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "\$$_walletAmmount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _setWalletAmmount(
                                    _walletAmmount + _changeWalletAmmountStep);
                              },
                              icon: Icon(Icons.add_circle_outline_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                            "Transactions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: transactionsList.isEmpty
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Are you sure you want to clear all transactions from the device?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
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
                                        ).then((value) async {
                                          if (value) {
                                            Navigator.of(context).pop();
                                            await _prefs.setStringList(
                                              SettingsDrawer.transactionsKey,
                                              [],
                                            );
                                          }
                                        });
                                      },
                                icon: Icon(Icons.delete),
                                label: Text(
                                  "Clear",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        if (transactionsList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "There is no trasactions. Please donate first.",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        if (transactionsList.isNotEmpty)
                          Column(
                            children: transactionsList.map((item) {
                              var transaction =
                                  Transaction.fromJson(jsonDecode(item));
                              var dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      transaction.timestamp);
                              var dateString = DateFormat("MMM dd hh:mm aaa")
                                  .format(dateTime);

                              return ListTile(
                                title: Text(
                                  dateString,
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Text(
                                  "\$${transaction.amount}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
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
