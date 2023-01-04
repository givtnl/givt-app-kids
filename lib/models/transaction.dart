class Transaction {
  final int timestamp;
  final double amount;

  Transaction({
    required this.timestamp,
    required this.amount,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        amount = json['amount'];

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'amount': amount,
      };
}
