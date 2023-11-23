import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';

enum AmplitudeEvent {
  amountPressed('amount_pressed'),
  backButtonPressed('back_button_pressed'),
  returnToHomePressed('return_to_home_pressed'),
  giveToThisGoalPressed('give_to_this_goal_pressed'),
  iWantToGiveToPressed('i_want_to_give_pressed'),
  choseGiveWithCoin('chose_give_with_coin'),
  choseGiveWithQRCode('chose_give_with_qr_code'),
  cancelGive('cancel_give'),
  helpMeFindCharityPressed('help_me_find_charity_pressed'),
  askToFindCharityPressed('ask_my_parents_to_find_charity_pressed'),
  loginPressed('login_pressed'),
  logOutPressed('log_out_pressed'),
  profilePressed('profile_pressed'),
  profileSwitchPressed('profile_switch_pressed'),
  assignCoinPressed('assign_coin_pressed'),
  qrCodeScanned('qr_code_scanned'),
  seeDonationHistoryPressed('see_donation_history_pressed'),
  nfcScanned('nfc_scanned'),
  locationSelected('location_selected'),
  nextToInterestsPressed('next_to_interests_pressed'),
  interestSelected('interest_selected'),
  nextToCharitiesPressed('next_to_charities_pressed'),
  charitiesShown('charities_shown'),
  charityCardPressed('charity_card_pressed'),
  accountLocked('account_locked_for_wrong_password'),
  walletTracker('wallet_tracker'),
  startScanningCoin('start_scanning_coin_in_app'),
  inAppCoinScannedSuccessfully('in_app_coin_scanned_successfully'),
  coinScannedError('coin_scanned_in_app_error'),
  deeplinkCoinScanned('deeplink_coin_scanned'),
  ;

  final String value;

  const AmplitudeEvent(this.value);
}

class AnalyticsHelper {
  static const String amountKey = "amount";
  static const String goalKey = "goal_name";
  static const String walletAmountKey = "wallet_amount";

  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    _amplitude = Amplitude.getInstance();
    await _amplitude!.init(key);
    await _amplitude!.enableCoppaControl();
    await _amplitude!.trackingSessionEvents(true);
  }

  static Future<void> setUserId(
      String profileName, List<Profile> profiles) async {
    final currentUserId = await _amplitude?.getUserId();
    final isNewUser = profileName != currentUserId;
    Map<String, double> walletTracker = {
      for (var profile in profiles)
        '${profile.firstName} ${profile.lastName}': profile.wallet.balance
    };

    log('The ${isNewUser ? 'new' : 'same'} amplitude user $profileName is set.');
    await _amplitude?.setUserId(profileName, startNewSession: isNewUser);
    await _amplitude?.logEvent(
      AmplitudeEvent.walletTracker.value,
      eventProperties: walletTracker,
    );
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
