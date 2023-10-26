class Transaction {
  const Transaction({
    required this.userId,
    required this.mediumId,
    required this.amount,
  });

  final String userId;
  final String mediumId;
  final double amount;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mediumId': mediumId,
      'amount': amount,
    };
  }
}
