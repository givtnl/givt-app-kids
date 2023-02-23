import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:givt_app_kids/models/child_transaction.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:givt_app_kids/models/profile.dart';
import 'package:givt_app_kids/helpers/api_helper.dart';
import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/models/monsters.dart';
import 'package:givt_app_kids/models/organisation.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class ProfilesProvider with ChangeNotifier {
  static const String profilesKey = "profilesKey";
  static const String activeProfileGuidKey = "activeProfileGuidKey";
  static const String transactionsKey = "transactionsKey";

  List<Profile> _profiles = [];

  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    var result = _transactions
        .where(
          (transaction) => transaction.profileGuid == _activeProfile?.guid,
        )
        .toList();
    result.sort();
    return result;
  }

  final String _accessToken;
  Profile? _activeProfile;

  Profile? get activeProfile => _activeProfile;
  bool get isProfileSelected => _activeProfile != null;

  List<Profile> get profiles => [..._profiles];

  ProfilesProvider(this._accessToken, this._profiles) {
    _initFromStorage();
  }

  Future<void> _initFromStorage() async {
    var prefs = await SharedPreferences.getInstance();

    List<Profile> profilesList = [];
    var savedProfiles = prefs.getStringList(profilesKey);
    if (savedProfiles != null) {
      for (var item in savedProfiles) {
        var profile = Profile.fromJson(jsonDecode(item));
        profilesList.add(profile);
      }
      _profiles = profilesList;
      dev.log("Loaded from storage ${_profiles.length} profiles");
    }

    var savedActiveProfileGuid = prefs.getString(activeProfileGuidKey);
    if (savedActiveProfileGuid != null && savedActiveProfileGuid.isNotEmpty) {
      _activeProfile = _profiles
          .firstWhere((profile) => profile.guid == savedActiveProfileGuid);
      dev.log("Active profile guid ${_activeProfile?.guid}");
    }

    List<Transaction> transactionsList = [];
    var savedTransactions = prefs.getStringList(transactionsKey);
    if (savedTransactions != null) {
      for (var item in savedTransactions) {
        var transaction = Transaction.fromJson(jsonDecode(item));
        transactionsList.add(transaction);
      }
      transactionsList.sort();
    }
    _transactions = transactionsList;

    notifyListeners();
  }

  Future<void> setActiveProfile(Profile? activeProfile) async {
    var profileGuid = activeProfile != null ? activeProfile.guid : "";
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(activeProfileGuidKey, profileGuid);
    _activeProfile = activeProfile;
    notifyListeners();
  }

  Future<void> _saveProfiles() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> encodedProfiles = [];
    for (var profile in _profiles) {
      dev.log("Name: ${profile.name}, balance: ${profile.balance}");
      encodedProfiles.add(jsonEncode(profile.toJson()));
    }
    dev.log("Saved to storage ${_profiles.length} profiles");
    await prefs.setStringList(profilesKey, encodedProfiles);
  }

  Future<void> fetchProfiles() async {
    try {
      final url = Uri.https(
        /*ApiHelper.apiURL*/ "kids-production-api.azurewebsites.net",
        ApiHelper.profilePath,
      );
      var response = await http.get(url, headers: {
        "Authorization": "Bearer $_accessToken",
      });
      dev.log("[fetchProfiles] STATUS CODE: ${response.statusCode}");
      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        List<Profile> fetchedList = [];
        List<Profile> sortedList = [];

        if (decodedBody is List) {
          for (var element in decodedBody) {
            fetchedList.add(
              Profile(
                guid: element["guid"],
                name: element["name"],
                balance: element["balance"],
                monster: Monsters.blue,
                createdAt: element["createdAt"],
              ),
            );
          }
          fetchedList.sort();

          for (var i = 0, j = 0; i < fetchedList.length; i++, j++) {
            var profile = fetchedList[i];
            sortedList.add(
              Profile(
                guid: profile.guid,
                name: profile.name,
                balance: profile.balance,
                monster: Monsters.values[j],
                createdAt: profile.createdAt,
              ),
            );

            if (j == Monsters.values.length - 1) {
              j = 0;
            }
          }

          _profiles = sortedList;
          if (_activeProfile != null) {
            _activeProfile = _profiles
                .firstWhere((profile) => profile.guid == _activeProfile!.guid);
          }
          await _saveProfiles();
          notifyListeners();
        }
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> createTransaction(Transaction transaction) async {
    try {
      final url = Uri.https(
        /*ApiHelper.apiURL*/ "kids-production-api.azurewebsites.net",
        ApiHelper.transactionPath(_activeProfile!.guid),
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $_accessToken",
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "destinationName": transaction.goalName,
          "amount": transaction.amount,
        }),
      );
      dev.log("[createTransaction] STATUS CODE: ${response.statusCode}");
      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        dev.log(decodedBody.toString());

        _transactions.add(transaction);
        await _saveTransactions();

        await AnalyticsHelper.logNewTransactionEvent(transaction);

        notifyListeners();
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> createTransactionNew(ChildTransaction transaction) async {
    try {
      final url = Uri.https(
        /*ApiHelper.apiURL*/ "kids-production-api.azurewebsites.net",
        ApiHelper.transactionPath(_activeProfile!.guid),
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $_accessToken",
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "destinationID": transaction.destinationID,
          "destinationName": transaction.destinationName,
          "destinationCampaignName": transaction.destinationCampaignName,
          "amount": transaction.amount,
        }),
      );
      dev.log("[createTransaction] STATUS CODE: ${response.statusCode}");
      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        dev.log(decodedBody.toString());

// TO DO: IMPLEMENT NORMAL TRANSACTION FUNCTIONALITY WITH THE UPDATED CLASS
        // _transactions.add(transaction);
        // await _saveTransactions();

        // await AnalyticsHelper.logNewTransactionEvent(transaction);

        notifyListeners();
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> clearProfiles() async {
    _profiles.clear();
    await setActiveProfile(null);
    await _saveProfiles();
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> encodedTransactions = [];
    for (var transaction in _transactions) {
      encodedTransactions.add(jsonEncode(transaction.toJson()));
    }
    await prefs.setStringList(transactionsKey, encodedTransactions);
  }

  Future<void> clearTransactions() async {
    _transactions = _transactions
        .takeWhile(
          (transaction) => transaction.profileGuid != _activeProfile?.guid,
        )
        .toList();
    await _saveTransactions();
    notifyListeners();
  }

  Future<Organisation> getOrganizationDetails(String barcode) async {
    try {
      final barcodeUri = Uri.parse(barcode);
      final mediumId = barcodeUri.queryParameters['code'];

      final url = Uri.https(
        ApiHelper.apiURL,
        ApiHelper.campaignsPath,
        {
          'code': mediumId,
        },
      );
      var response = await http.get(
        url,
        // headers: {
        //   "Authorization": "Bearer $_accessToken",
        // },
      );

      dev.log("[getOrganizationDetails] STATUS CODE: ${response.statusCode}");
      if (response.statusCode < 400) {
        Map<String, dynamic> decoded = json.decode(response.body);
        var organisation = Organisation.fromJson(decoded);
        return organisation;
      } else {
        throw Exception(response.body);
      }
    } catch (error, stackTrace) {
      dev.log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
