import 'package:equatable/equatable.dart';

class Allowance extends Equatable {
  const Allowance({
    required this.amount,
    required this.date,
  });

  final double amount;
  final DateTime date;

  @override
  List<Object?> get props => [
        amount,
        date,
      ];

  Allowance.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
        );

  factory Allowance.fromMap(Map<String, dynamic> map) {
    return Allowance(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate']) ?? DateTime.now(),
    );
  }
}
