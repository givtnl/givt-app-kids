import 'package:equatable/equatable.dart';

enum DonationState {
  pending(status: 'Pending'),
  approved(status: 'Approved'),
  declined(status: 'Declined');

  final String status;
  const DonationState({required this.status});
}

enum DonationMedium {
  qr(medium: 'QR'),
  manual(medium: 'NFC');

  final String medium;
  const DonationMedium({required this.medium});
}

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
      amount: double.parse(map['amount'].toString()),
      date: DateTime.parse(map['dateCreated']),
      organizationName: map['organizationName'],
      state: DonationState.values.firstWhere(
        (element) => element.status == map['state'],
      ),
      medium: DonationMedium.values.firstWhere(
        (element) => element.medium == map['medium'],
      ),
    );
  }
}
