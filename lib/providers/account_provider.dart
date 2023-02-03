import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class AccountProvider with ChangeNotifier {
  static const String nameKey = "nameKey";
  static const String ageKey = "ageKey";

  static const String nameDefault = "Jackson";
  static const int ageDefault = 11;

  String _name = nameDefault;
  int _age = ageDefault;

  AccountProvider() {
    _initFromStorage();
  }

  Future<void> _initFromStorage() async {
    var prefs = await SharedPreferences.getInstance();

    var savedName = prefs.getString(nameKey);
    _name = savedName ?? nameDefault;

    var savedAge = prefs.getInt(ageKey);
    _age = savedAge ?? ageDefault;

    await AnalyticsHelper.setDefaultParameters(userName: _name, userAge: _age);

    notifyListeners();
  }

  String get name => _name;
  int get age => _age;

  Future<void> setName(String newName) async {
    _name = newName;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, newName);
    await AnalyticsHelper.setDefaultParameters(userName: _name, userAge: _age);
    notifyListeners();
  }

  Future<void> setAge(int newAge) async {
    _age = newAge;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ageKey, newAge);
    await AnalyticsHelper.setDefaultParameters(userName: _name, userAge: _age);
    notifyListeners();
  }
}
