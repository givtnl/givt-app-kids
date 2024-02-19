import 'package:equatable/equatable.dart';

class FamilyGoal extends Equatable {
  const FamilyGoal({
    required this.goalAmount,
    required this.amount,
    required this.mediumId,
    required this.status,
    required this.dateCreated,
    required this.orgName,
  });

  const FamilyGoal.empty()
      : this(
          goalAmount: 0,
          amount: 0,
          mediumId: '',
          status: FamilyGoalStatus.init,
          dateCreated: '2024-01-01T10:00:00Z',
          orgName: '',
        );

  factory FamilyGoal.fromMap(Map<String, dynamic> map) {
    return FamilyGoal(
      goalAmount: map['goal'] as int,
      amount: (map['amount'] as num).toDouble(),
      mediumId: map['mediumId'] as String,
      status: FamilyGoalStatus.fromString(map['status'] as String),
      dateCreated: map['dtCreated'] as String,
      // TODO: Change when endpoint is updated
      orgName: map['orgName'] as String,
    );
  }

  final int goalAmount;
  final double amount;
  final String mediumId;
  final FamilyGoalStatus status;
  final String dateCreated;
  final String orgName;

  @override
  List<Object?> get props =>
      [goalAmount, amount, mediumId, status, dateCreated, orgName];

  String toJson() {
    return '''
    {
      "goal": $goalAmount,
      "amount": $amount,
      "mediumId": "$mediumId",
      "status": "${status.value}",
      "dtCreated": "$dateCreated",
      "orgName": "$orgName"
    }
    ''';
  }
}

enum FamilyGoalStatus {
  inProgress('InProgress'),
  completed('Completed'),
  init('init');

  const FamilyGoalStatus(this.value);

  final String value;

  static FamilyGoalStatus fromString(String value) {
    return FamilyGoalStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => FamilyGoalStatus.inProgress,
    );
  }
}
