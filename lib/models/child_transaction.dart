import 'package:json_annotation/json_annotation.dart';

part 'child_transaction.g.dart';

@JsonSerializable()
class ChildTransaction {
  final String guid;
  final String createdAt;
  final String destinationID;
  final String destinationName;
  final String destinationCampaignName;
  final double amount;

  ChildTransaction(
      {required this.guid,
      required this.createdAt,
      required this.destinationID,
      required this.destinationName,
      required this.destinationCampaignName,
      required this.amount
      });

  factory ChildTransaction.fromJson(Map<String, dynamic> json) =>
      _$ChildTransactionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChildTransactionToJson(this);

  static List<ChildTransaction> fromListJson(List<dynamic> json) {
    return json.map((e) => ChildTransaction.fromJson(e)).toList();
  }
}
