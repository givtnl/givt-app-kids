enum GivtInnerErrorType {
  none(code: -1, errorMessage: ''),
  wrongPasswordFirstAttempt(code: 2, errorMessage: 'You have 2 attempts left.'),
  wrongPasswordSecondAttempt(code: 1, errorMessage: 'You have 1 attempt left.'),
  wrongPasswordLocked(code: 3, errorMessage: ''),
  wrongPasswordOrUser(code: 6, errorMessage: '');

  const GivtInnerErrorType({
    required this.code,
    required this.errorMessage,
  });

  final int code;
  final String errorMessage;

  bool get isWrongPassword {
    return this == GivtInnerErrorType.wrongPasswordFirstAttempt ||
        this == GivtInnerErrorType.wrongPasswordSecondAttempt;
  }

  static GivtInnerErrorType fromJson(Map<String, dynamic> json) {
    final code = int.tryParse(json['ErrorCode']) ?? -1;
    return GivtInnerErrorType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => GivtInnerErrorType.none,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ErrorCode': code.toString(),
    };
  }
}
