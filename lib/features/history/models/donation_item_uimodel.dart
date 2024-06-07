import 'dart:ui';

import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/helpers/datetime_extension.dart';
import 'package:givt_app_kids/helpers/donation_state.dart';

class DonationItemUIModel {
  const DonationItemUIModel({required this.donation});

  final Donation donation;

  String get leadingSVGAsset => DonationState.getPicture(donation.state);
  double get amount => donation.amount;
  Color get amountColor => DonationState.getAmountColor(donation.state);
  String get title => '${donation.isToGoal ? 'Family Goal: ' : ''}'
      '${donation.organizationName}';
  String get dateText => donation.state == DonationState.pending
      ? 'Waiting for approval...'
      : donation.date.formatDate();
  String get trailingSvgAsset =>
      donation.medium == DonationMediumType.nfc || donation.isToGoal
          ? donation.isToGoal
              ? 'assets/images/goal_flag.svg'
              : 'assets/images/coin.svg'
          : '';
  double get trailingSvgAssetOpacity =>
      donation.state == DonationState.pending ? 0.6 : 1.0;
}
