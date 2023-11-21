import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';

enum AmplitudeEvent {
  amountPressed('amount_pressed'),
  backButtonPressed('back_button_pressed'),
  // continuePressed('continue_pressed'),
  giveToThisGoalPressed('give_to_this_goal_pressed'),
  iWantToGiveToPressed('i_want_to_give_pressed'),
  helpMeFindCharityPressed('help_me_find_charity_pressed'),
  askToFindCharityPressed('ask_my_parents_to_find_charity_pressed'),
  loginPressed('login_pressed'),
  profilePressed('profile_pressed'),
  profileSwitchPressed('profile_switch_pressed'),
  // newTransaction('new_transaction'),
  buttonPressed('button_pressed'),
  qrCodeScanned('qr_code_scanned'),
  seeDonationHistoryPressed('see_donation_history_pressed'),
  nfcScanned('nfc_scanned'),
  // drawerLongPressed('drawer_long_pressed'),
  // logoutPressed('logout_pressed'),
  ;

  final String value;

  const AmplitudeEvent(this.value);
}

class AnalyticsHelper {
  // static const String userNameKey = "user_name";
  // static const String userAgeKey = "user_age";
  // static const String newTransactionKey = "new_transaction";
  // static const String amountKey = "amount";
  // static const String goalKey = "goal_name";
  // static const String walletAmountKey = "wallet_amount";
  // static const String buttonPressedKey = "button_pressed";
  // static const String buttonNameKey = "button_name";
  static const String screenNameKey = "screen_name";
  // static const String timestampKey = "timestamp";
  // static const String formattedDateKey = "formatted_date";

  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    _amplitude = Amplitude.getInstance();
    await _amplitude!.init(key);
    await _amplitude!.enableCoppaControl();
    await _amplitude!.trackingSessionEvents(true);
  }

  static Future<void> setUserId(String profileName) async {
    final currentUserId = await _amplitude?.getUserId();
    final isNewUser = profileName != currentUserId;

    log('The ${isNewUser ? 'new' : 'same'} amplitude user $profileName is set');
    await _amplitude?.setUserId(profileName, startNewSession: isNewUser);
  }

  static Future<void> logEvent({
    required AmplitudeEvent eventName,
    Map<String, dynamic>? eventProperties,
  }) async {
    await _amplitude?.logEvent(
      eventName.value,
      eventProperties: eventProperties,
    );

    log('${eventName.value} pressed with properties: $eventProperties');
  }
}
