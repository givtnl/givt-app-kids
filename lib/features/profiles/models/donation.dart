import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/helpers/donation_helpers.dart';

class Donation extends Equatable {
  const Donation({
    required this.amount,
    required this.date,
    required this.organizationName,
    required this.state,
    required this.medium,
  });

  final double amount;
  final DateTime date;
  final String organizationName;
  final DonationState state;
  final DonationMedium medium;

  @override
  List<Object?> get props => [
        amount,
        date,
        organizationName,
        state,
        medium,
      ];

  Donation.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          organizationName: '',
          state: DonationState.pending,
          medium: DonationMedium.qr,
        );

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
        amount: double.tryParse(map['amount'].toString()) ?? 0,
        date: DateTime.tryParse(map['donationDate']) ?? DateTime.now(),
        organizationName: map['collectGroupName'] ?? '',
        state: getState(map['status']),
        medium: DonationMedium.values.firstWhere(
          (element) => element.medium == map['mediumType'],
          orElse: () => DonationMedium.unknown,
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'collectGroupName': organizationName,
      'status': getDonationStateString(state),
      'mediumType': medium.medium,
    };
  }
}
