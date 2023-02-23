class Transaction implements Comparable {
  final String createdAt;
  final double amount;
  final String destinationName;
  final String parentGuid;

  Transaction({
    required this.createdAt,
    required amount,
    required this.parentGuid,
    required this.destinationName,
  }) : amount = double.parse(amount.toStringAsFixed(2));

  Transaction.fromJson(Map<String, dynamic> json)
      : parentGuid = json["parentGuid"],
        createdAt = json["createdAt"],
        amount = json["amount"],
        destinationName = json["destinationName"];

  Map<String, dynamic> toJson() => {
        "parentGuid": parentGuid,
        "createdAt": createdAt,
        "amount": amount,
        "destinationName": destinationName,
      };

  @override
  int compareTo(other) {
    var createdAtThis = DateTime.parse(createdAt);
    var createdAtOther = DateTime.parse(other.createdAt);
    return createdAtOther.compareTo(createdAtThis);
  }
}
