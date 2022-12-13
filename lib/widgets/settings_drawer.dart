// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SettingsDrawer extends StatefulWidget {
  static const String nameKey = "nameKey";
  static const String ageKey = "ageKey";

  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final TextEditingController _nameTextController = TextEditingController();

  late final StreamingSharedPreferences _prefs;

  String _userName = "James";
  int _userAge = 10;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  void _readPreferences() async {
    _prefs = await StreamingSharedPreferences.instance;
    var name = _prefs.getString(SettingsDrawer.nameKey, defaultValue: "");
    var age = _prefs.getInt(SettingsDrawer.ageKey, defaultValue: 0);
    setState(() {
      _userName = name.getValue();
      _nameTextController.text = _userName;
      _userAge = age.getValue();
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
