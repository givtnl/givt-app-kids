import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:intl/intl.dart';

import 'package:givt_app_kids/models/transaction.dart';

class AnalyticsHelper {
  static const String userNameKey = "user_name";
  static const String userAgeKey = "user_age";
  static const String newTransactionKey = "new_transaction";
  static const String amountKey = "amount";
  static const String goalKey = "goal_name";
  static const String walletAmountKey = "wallet_amount";
  static const String buttonPressedKey = "button_pressed";
  static const String buttonNameKey = "button_name";
  static const String screenNameKey = "screen_name";
  static const String timestampKey = "timestamp";
  static const String formattedDateKey = "formatted_date";

  static Future<void> setDefaultParameters(
      {required String userName, required int userAge}) async {
    final identify = Identify()
      ..set('username', userName)
      ..set('age', userAge);

    Amplitude.getInstance().identify(identify);
  }

  static String _getFormattedTime(DateTime now) {
    var dateString = DateFormat("MMM dd hh:mm aaa").format(now);
    return dateString;
  }

  static Future<void> logNewTransactionEvent(Transaction transaction) async {
    var now = DateTime.now();

    Amplitude.getInstance().logEvent(
      newTransactionKey,
      eventProperties: {
        amountKey: transaction.amount,
        goalKey: transaction.destinationName,
        timestampKey: now.millisecondsSinceEpoch,
        formattedDateKey: _getFormattedTime(now),
      },
    );
  }

  // static Future<void> logWalletAmountEvent(double amount) async {
  //   var now = DateTime.now();
  //   Amplitude.getInstance().logEvent(
  //     walletAmountKey,
  //     eventProperties: {
  //       amountKey: amount,
  //       timestampKey: now.millisecondsSinceEpoch,
  //       formattedDateKey: _getFormattedTime(now),
  //     },
  //   );
  // }

  static Future<void> logButtonPressedEvent(
      String buttonName, String screenName) async {
    var now = DateTime.now();
    Amplitude.getInstance().logEvent(
      buttonPressedKey,
      eventProperties: {
        buttonNameKey: buttonName,
        screenNameKey: screenName,
        timestampKey: now.millisecondsSinceEpoch,
        formattedDateKey: _getFormattedTime(now),
      },
    );
  }
}
