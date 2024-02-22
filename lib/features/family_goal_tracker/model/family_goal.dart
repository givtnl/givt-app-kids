import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'family_goal.freezed.dart';
part 'family_goal.g.dart';

@freezed
class FamilyGoal with _$FamilyGoal {
  const FamilyGoal._();

  const factory FamilyGoal({
    required num goal,
    required num amount,
    required num totalAmount,
    required String mediumId,
    required FamilyGoalStatus status,
    required String creationDate,
    required String collectGroupName,
    required String id,
  }) = _FamilyGoal;

  factory FamilyGoal.fromJson(Map<String, Object?> json) =>
      _$FamilyGoalFromJson(json);

  factory FamilyGoal.empty() => const _FamilyGoal(
        goal: 0,
        amount: 0,
        totalAmount: 0,
        mediumId: '',
        status: FamilyGoalStatus.init,
        creationDate: '2024-01-01T10:00:00Z',
        collectGroupName: '',
        id: '',
      );

  bool get isActive => status == FamilyGoalStatus.inProgress;
}

enum FamilyGoalStatus {
  @JsonValue('InProgress')
  inProgress,
  @JsonValue('Completed')
  completed,
  init;
}
