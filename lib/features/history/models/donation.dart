import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/helpers/donation_state.dart';

class HistoryItem extends Equatable {
  const HistoryItem({
    required this.amount,
    required this.date,
    required this.organizationName,
    required this.state,
    required this.medium,
    required this.type,
  });

  final double amount;
  final DateTime date;
  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;
  final HistoryTypes type;

  @override
  List<Object?> get props => [
        amount,
        date,
        organizationName,
        state,
        medium,
      ];

  HistoryItem.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          organizationName: '',
          state: DonationState.pending,
          medium: DonationMediumType.qr,
          type: HistoryTypes.donation,
        );

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    final type = HistoryTypes.getType(map);
    return HistoryItem(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate']) ?? DateTime.now(),
      organizationName: map['collectGroupName'] ?? '',
      state: DonationState.getState(map['status']),
      medium: DonationMediumType.values.firstWhere(
          (element) => element.type == map['mediumType'],
          orElse: () => DonationMediumType.unknown),
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'collectGroupName': organizationName,
      'status': DonationState.getDonationStateString(state),
      'mediumType': medium.type,
    };
  }
}

enum HistoryTypes {
  donation('WalletDonation'),
  allowance('RecurringAllowance');

  static HistoryTypes getType(Map<String, dynamic> map) {
    if (map['mediumType'] == HistoryTypes.allowance.value) {
      return HistoryTypes.allowance;
    }
    return HistoryTypes.donation;
  }

  final String value;
  const HistoryTypes(this.value);
}
