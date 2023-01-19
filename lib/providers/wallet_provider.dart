import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class WalletProvider with ChangeNotifier {
  static const String totalAmountKey = "totalAmountKey";
  static const String transactionsKey = "transactionsKey";

  static const double totalAmountDefault = 20.0;

  double _totalAmount = 0;
  List<Transaction> _transactions = [];

  double get totalAmount => _totalAmount;

  List<Transaction> get transactions {
    var result = [..._transactions];
    result.sort();
    return result;
  }

  WalletProvider() {
    _initFromStorage();
  }

  Future<void> _initFromStorage() async {
    var prefs = await SharedPreferences.getInstance();

    var savedTotalAmount = prefs.getDouble(totalAmountKey);
    _totalAmount = savedTotalAmount ?? totalAmountDefault;

    List<Transaction> list = [];
    var savedTransactions = prefs.getStringList(transactionsKey);
    if (savedTransactions != null) {
      for (var item in savedTransactions) {
        var transaction = Transaction.fromJson(jsonDecode(item));
        list.add(transaction);
      }
      list.sort();
    }
    _transactions = list;

    notifyListeners();
  }

  Future<void> setAmount(double amount) async {
    var prefs = await SharedPreferences.getInstance();
    _totalAmount = amount;
    await prefs.setDouble(totalAmountKey, _totalAmount);
    await AnalyticsHelper.logWalletAmountEvent(_totalAmount);
    notifyListeners();
  }

  Future<void> createTransaction(Transaction transaction) async {
    var prefs = await SharedPreferences.getInstance();
    _transactions.add(transaction);

    _saveTransactions(prefs);

    await AnalyticsHelper.logNewTransactionEvent(transaction);
    await setAmount(_totalAmount - transaction.amount);

    notifyListeners();
  }

  Future<void> _saveTransactions(SharedPreferences prefs) async {
    List<String> encodedTransactions = [];
    for (var transaction in _transactions) {
      encodedTransactions.add(jsonEncode(transaction.toJson()));
    }
    await prefs.setStringList(transactionsKey, encodedTransactions);
  }

  Future<void> clearTransactions() async {
    var prefs = await SharedPreferences.getInstance();
    _transactions.clear();
    _saveTransactions(prefs);
    notifyListeners();
  }
}
