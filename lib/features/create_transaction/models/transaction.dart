class Transaction {
  const Transaction(
      {this.amount = 0.0,
      this.destinationName = '',
      this.parentGuid = '',
      this.userId = '',
      this.donationType = DonationType.AdHocDonation,
      this.collectId = '',
      this.createdAt = ''});

  final double amount;
  final String destinationName;
  final String parentGuid;
  final String userId;
  final DonationType donationType;
  final String collectId;
  final String createdAt;
}

enum DonationType { AdHocDonation, RecurringDonation }
