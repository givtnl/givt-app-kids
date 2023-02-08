class Transaction implements Comparable {
  final int timestamp;
  final double amount;
  final String goalName;
  final String profileGuid;

  Transaction(
      {required this.timestamp,
      required amount,
      required this.profileGuid,
      required this.goalName})
      : amount = double.parse(amount.toStringAsFixed(2));

  Transaction.fromJson(Map<String, dynamic> json)
      : timestamp = json["timestamp"],
        amount = json["amount"],
        goalName = json["goalName"],
        profileGuid =
            json.containsKey("profileGuid") ? json["profileGuid"] : "";

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "amount": amount,
        "profileGuid": profileGuid,
        "goalName" : goalName,
      };

  @override
  int compareTo(other) {
    if (timestamp == other.timestamp) return 0;
    return timestamp > other.timestamp ? -1 : 1;
  }
}
