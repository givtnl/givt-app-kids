import 'package:givt_app_kids/features/history/models/history_item.dart';

class Allowance extends HistoryItem {
  const Allowance({
    required super.amount,
    required super.date,
    required super.type,
  });

  @override
  List<Object?> get props => [amount, date, type];

  Allowance.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          type: HistoryTypes.donation,
        );

  factory Allowance.fromMap(Map<String, dynamic> map) {
    return Allowance(
        amount: double.tryParse(map['amount'].toString()) ?? 0,
        date: DateTime.tryParse(map['donationDate']) ?? DateTime.now(),
        type: HistoryTypes.values.firstWhere(
          (element) => element.value == map['donationType'],
        ));
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'donationType': type.value,
    };
  }
}
