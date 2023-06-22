class Transaction {
  const Transaction({
    required this.userId,
    required this.campaignId,
    required this.collectId,
    this.donationType = DonationType.AdHocDonation,
    required this.amount,
  });

  final String userId;
  final String campaignId;
  final String collectId;
  final DonationType donationType;
  final double amount;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'campaignId': campaignId,
      'collectId': collectId,
      'donationType': donationType.name,
      'amount': amount,
    };
  }
}

enum DonationType { AdHocDonation, RecurringDonation }
