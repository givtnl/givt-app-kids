class Transaction implements Comparable {
  final String createdAt;
  final double amount;
  final String destinationName;
  final String parentGuid;

  Transaction(
      {required this.createdAt,
      required amount,
      required this.parentGuid,
      this.destinationName = "Christ Pres Chruch -b"})
      : amount = double.parse(amount.toStringAsFixed(2));

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
    DateTime createdAtDateTimeThis = DateTime.parse(createdAt);
    DateTime createdAtDateTimeOther = DateTime.parse(other.createdAt);
    if (createdAtDateTimeThis.millisecondsSinceEpoch ==
        createdAtDateTimeOther.millisecondsSinceEpoch) return 0;
    return createdAtDateTimeThis.millisecondsSinceEpoch >
            createdAtDateTimeOther.millisecondsSinceEpoch
        ? -1
        : 1;
  }
}
