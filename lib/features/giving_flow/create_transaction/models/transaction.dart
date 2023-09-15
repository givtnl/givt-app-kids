class Transaction {
  const Transaction({
    required this.userId,
    required this.collectGroupId,
    required this.mediumId,
    this.donationType = DonationType.AdHocDonation,
    required this.amount,
  });

  final String userId;
  final String collectGroupId;
  final String mediumId;
  final DonationType donationType;
  final double amount;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'collectGroupId': collectGroupId,
      'mediumId': mediumId,
      'donationType': donationType.name,
      'amount': amount,
    };
  }
}

enum DonationType { AdHocDonation, RecurringDonation }
