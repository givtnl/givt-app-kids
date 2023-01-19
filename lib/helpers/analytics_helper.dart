import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';

import 'package:givt_app_kids/models/transaction.dart';

class AnalyticsHelper {
  static const String userNameKey = "user_name";
  static const String userAgeKey = "user_age";
  static const String newTransactionKey = "new_transaction";
  static const String amountKey = "amount";
  static const String walletAmountKey = "wallet_amount";
  static const String buttonPressedKey = "button_pressed";
  static const String buttonNameKey = "button_name";
  static const String screenNameKey = "screen_name";
  static const String timestampKey = "timestamp";
  static const String formattedDateKey = "formatted_date";

  static Future<void> setDefaultParameters({required String userName, required int userAge}) async {
    await FirebaseAnalytics.instance.setDefaultEventParameters({
      userNameKey: userName,
      userAgeKey: userAge,
    });
  }

  static String _getFormattedTime(DateTime now) {
    var dateString = DateFormat("MMM dd hh:mm aaa").format(now);
    return dateString;
  }

  static Future<void> logNewTransactionEvent(Transaction transaction) async {
    var now = DateTime.now();
    await FirebaseAnalytics.instance.logEvent(
      name: newTransactionKey,
      parameters: {
        amountKey: transaction.amount,
        timestampKey: now.millisecondsSinceEpoch,
        formattedDateKey: _getFormattedTime(now),
      },
    );
  }

  static Future<void> logWalletAmountEvent(double amount) async {
    var now = DateTime.now();
    await FirebaseAnalytics.instance.logEvent(
      name: walletAmountKey,
      parameters: {
        amountKey: amount,
        timestampKey: now.millisecondsSinceEpoch,
        formattedDateKey: _getFormattedTime(now),
      },
    );
  }

  static Future<void> logScreenView(String screenName) async {
    await FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
    );
  }

  static Future<void> logButtonPressedEvent(
      String buttonName, String screenName) async {
    var now = DateTime.now();
    await FirebaseAnalytics.instance.logEvent(
      name: buttonPressedKey,
      parameters: {
        buttonNameKey: buttonName,
        screenNameKey: screenName,
        timestampKey: now.millisecondsSinceEpoch,
        formattedDateKey: _getFormattedTime(now),
      },
    );
  }
}
