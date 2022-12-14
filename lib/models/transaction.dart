class Transaction implements Comparable {
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

  @override
  int compareTo(other) {
    if (timestamp == other.timestamp) return 0;
    return timestamp > other.timestamp ? -1 : 1;
  }
}
