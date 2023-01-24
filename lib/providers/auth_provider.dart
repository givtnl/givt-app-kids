import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String apiURL = "givt-debug-api.azurewebsites.net";

  static const String accessTokenKey = "accessTokenKey";
  static const String guidKey = "guidKey";

  String _accessToken = "";
  String _guid = "";

  AuthProvider() {
    _initFromStorage();
  }

  bool get isAuthenticated {
    return _accessToken.isNotEmpty && _guid.isNotEmpty;
  }

  String get accessToken => _accessToken;
  String get guid => _guid;

  Future<void> _initFromStorage() async {
    var prefs = await SharedPreferences.getInstance();

    var savedAccessToken = prefs.getString(accessTokenKey);
    _accessToken = savedAccessToken ?? "";

    var savedGuid = prefs.getString(guidKey);
    _guid = savedGuid ?? "";

    dev.log("LOADED TOKEN: $_accessToken");
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, _accessToken);
    await prefs.setString(guidKey, _guid);
    dev.log("SAVED TOKEN: $_accessToken");
  }

  Future<void> login({required String email, required String password}) async {
    final url = Uri.https(apiURL, '/oauth2/token');

    try {
      var response = await http.post(
        url,
        body: {
          'grant_type': 'password',
          'userName': email,
          'password': password
        },
      );

      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        final responseDecodedData = decodedBody as Map<String, dynamic>;
        _accessToken = responseDecodedData["access_token"];
        _guid = responseDecodedData["GUID"];
//        final refresh_token = responseDecodedData["refresh_token"];
        await _saveToStorage();
        notifyListeners();
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    _accessToken = "";
    _guid = "";
    await _saveToStorage();
    notifyListeners();
  }
}
