import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';

enum AmplitudeEvent {
  amountPressed('amount_pressed'),
  backButtonPressed('back_button_pressed'),
  returnToHomePressed('return_to_home_pressed'),
  giveToThisGoalPressed('give_to_this_goal_pressed'),
  iWantToGivePressed('i_want_to_give_pressed'),
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
  locationSelected('location_selected'),
  citySelected('city_selected'),
  interestSelected('interest_selected'),
  showCharitiesPressed('show_charities_pressed'),
  charitiesShown('charities_shown'),
  donateToRecommendedCharityPressed('donate_to_recommended_charity_pressed'),
  charityCardPressed('charity_card_pressed'),
  accountLocked('account_locked_for_wrong_password'),
  walletTracker('wallet_tracker'),
  startScanningCoin('in_app_start_scanning_coin'),
  inAppCoinScannedSuccessfully('in_app_coin_scanned_successfully'),
  coinScannedError('in_app_coin_scanned_error'),
  deeplinkCoinScanned('deeplink_coin_scanned'),
  organisationSelected('organisation_is_set'),
  editAvatarIconClicked('edit_avatar_icon_clicked'),
  avatarImageSelected('avatar_image_selected'),
  editProfilePictureClicked('edit_profile_picture_clicked'),
  saveAvatarClicked('save_avatar_clicked'),
  rewardAchieved('reward_achieved'),
  goalTrackerTapped('goal_tracker_tapped'),
  goalDismissed('goal_dismissed'),
  donateToThisFamilyGoalPressed('donate_to_this_family_goal_pressed'),
  choseGiveToFamilyGoal('chose_give_to_family_goal'),
  schoolEventFlowStartButtonClicked('school_event_flow_start_button_clicked'),
  schoolEventFlowLoginButtonClicked('school_event_flow_login_button_clicked'),
  schoolEventFlowConfirmButtonClicked(
      'school_event_flow_confirm_button_clicked'),
  schoolEventLogOutTriggered('school_event_log_out_triggered'),
  openAppPermissionsSettings('open_app_permissions_settings'),
  openCameraPermissionDialog('open_camera_permission_dialog'),
  closePermissionsDialog('close_permissions_dialog'),
  navigationBarPressed('navigation_bar_pressed'),
  ;

  final String value;

  const AmplitudeEvent(this.value);
}

class AnalyticsHelper {
  static const String amountKey = "amount";
  static const String goalKey = "goal_name";
  static const String walletAmountKey = "wallet_amount";
  static const String mediumIdKey = "medium_id";
  static const String locationKey = "location";
  static const String interestKey = "all_selected_interests";
  static const String recommendedCharitiesKey = "recommended_charities";
  static const String charityNameKey = "charity_name";
  static const String avatarImageKey = 'avatar_image_selected';
  static const String rewardKey = 'reward';
  static const String cityKey = 'city';
  static const String dateEUKey = 'start_date_eu_format';
  static const String familyNameKey = 'family_name';

  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    _amplitude = Amplitude.getInstance();
    await _amplitude!.init(key);
    await _amplitude!.enableCoppaControl();
    await _amplitude!.trackingSessionEvents(true);
  }

  static Future<void> setUserProperties(Profile profile) async {
    final currentUserId = await _amplitude?.getUserId();
    final isNewUser = profile.id != currentUserId;

    log('The ${isNewUser ? 'new' : 'same'} amplitude user ${profile.id} is set.');
    await _amplitude?.setUserId(profile.id, startNewSession: isNewUser);
    await _amplitude?.setUserProperties({
      'First Name': profile.firstName,
    });
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
