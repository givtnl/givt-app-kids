// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildTransaction _$ChildTransactionFromJson(Map<String, dynamic> json) =>
    ChildTransaction(
      guid: json['guid'] as String,
      createdAt: json['createdAt'] as String,
      destinationID: json['destinationID'] as String,
      destinationName: json['destinationName'] as String,
      destinationCampaignName: json['destinationCampaignName'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ChildTransactionToJson(ChildTransaction instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'createdAt': instance.createdAt,
      'destinationID': instance.destinationID,
      'destinationName': instance.destinationName,
      'destinationCampaignName': instance.destinationCampaignName,
      'amount': instance.amount,
    };
