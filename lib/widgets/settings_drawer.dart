// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/helpers/flows.dart';

class SettingsDrawer extends StatefulWidget {
  static const String nameKey = "nameKey";
  static const String ageKey = "ageKey";
  static const String walletKey = "walletKey";
  static const String flowKey = "flowKey";

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
  Flows _selectedFlow = Flows.flow_1;

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
    var selectedFlow = _prefs.getInt(SettingsDrawer.flowKey, defaultValue: 0);

    setState(() {
      _userName = name.getValue();
      _nameTextController.text = _userName;
      _userAge = age.getValue();
      _walletAmmount = walletAmmount.getValue();
      _selectedFlow = Flows.values[selectedFlow.getValue()];
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

  void _setSelectedFlow(Flows flow) {
    _prefs.setInt(SettingsDrawer.flowKey, flow.index);
    if (_selectedFlow != flow) {
      Navigator.of(context).popUntil(
        ModalRoute.withName("/wallet"),
      );
    }
    setState(() {
      _selectedFlow = flow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Settings",
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
                                _setWalletAmmount(
                                    _walletAmmount - _changeWalletAmmountStep);
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
                          "Flows",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListTile(
                        title: Text(Flows.flow_1.name),
                        leading: Radio<Flows>(
                          value: Flows.flow_1,
                          groupValue: _selectedFlow,
                          onChanged: (Flows? value) {
                            _setSelectedFlow(value ?? _selectedFlow);
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(Flows.flow_2.name),
                        leading: Radio<Flows>(
                          value: Flows.flow_2,
                          groupValue: _selectedFlow,
                          onChanged: (Flows? value) {
                            _setSelectedFlow(value ?? _selectedFlow);
                          },
                        ),
                      ),
                    ],
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
