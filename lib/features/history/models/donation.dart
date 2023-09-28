import 'package:givt_app_kids/features/history/models/history.dart';
import 'package:givt_app_kids/helpers/donation_state.dart';

class Donation extends HistoryItem {
  const Donation({
    required super.amount,
    required super.date,
    required this.organizationName,
    required this.state,
    required this.medium,
    required super.type,
  });
  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;

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
          medium: DonationMediumType.qr,
          type: HistoryTypes.donation,
        );

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate']) ?? DateTime.now(),
      organizationName: map['collectGroupName'] ?? '',
      state: DonationState.getState(map['status']),
      medium: DonationMediumType.values.firstWhere(
          (element) => element.type == map['mediumType'],
          orElse: () => DonationMediumType.unknown),
      type: HistoryTypes.values.firstWhere(
        (element) => element.value == map['donationType'],
        orElse: () => HistoryTypes.donation,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'collectGroupName': organizationName,
      'status': DonationState.getDonationStateString(state),
      'mediumType': medium.type,
      'donationType': type.value,
    };
  }
}
