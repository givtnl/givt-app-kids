class Transaction implements Comparable {
  final int timestamp;
  final double amount;
  final String goalName = "Presbyterian Church Tulsa";

  Transaction({
    required this.timestamp,
    required amount,
  }) : amount = double.parse(amount.toStringAsFixed(2));

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
