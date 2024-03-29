part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [];
}

class LoggedOutState extends AuthState {
  const LoggedOutState();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class LoadingState extends AuthState {
  const LoadingState();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class InputFieldErrorState extends AuthState {
  const InputFieldErrorState({
    this.emailErrorMessage = '',
    this.passwordErrorMessage = '',
  });

  final String emailErrorMessage;
  final String passwordErrorMessage;

  @override
  List<Object?> get props => [emailErrorMessage, passwordErrorMessage];

  factory InputFieldErrorState.fromJson(Map<String, dynamic> json) {
    return InputFieldErrorState(
      emailErrorMessage: json['emailErrorMessage'],
      passwordErrorMessage: json['passwordErrorMessage'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'emailErrorMessage': emailErrorMessage,
      'passwordErrorMessage': passwordErrorMessage,
    };
  }
}

class ExternalErrorState extends AuthState {
  const ExternalErrorState({
    this.errorMessage = '',
    this.innerErrorType = GivtInnerErrorType.none,
  });

  final String errorMessage;
  final GivtInnerErrorType innerErrorType;

  @override
  List<Object?> get props => [errorMessage, innerErrorType];

  factory ExternalErrorState.fromJson(Map<String, dynamic> json) {
    final innerErrorsList = json['InnerErrors'];

    final innerErrorType = ((innerErrorsList ?? []) as List).isNotEmpty
        ? GivtInnerErrorType.fromJson(innerErrorsList[0])
        : GivtInnerErrorType.none;

    return ExternalErrorState(
      errorMessage: json['ErrorMessage'],
      innerErrorType: innerErrorType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ErrorMessage': errorMessage,
      'InnerErrors': [innerErrorType.toJson()],
    };
  }
}

class LoggedInState extends AuthState {
  static const int _currentVersion = 1;
  static const String _versionKey = '_versionKey';

  const LoggedInState({
    this.schoolEventMode = false,
  });

  final bool schoolEventMode;

  bool get isSchoolEvenMode {
    return schoolEventMode;
  }

  factory LoggedInState.fromJson(Map<String, dynamic> json) {
    //versioning to prevent user logout when app be updated
    final version = getIt<SharedPreferences>().getInt(_versionKey);
    switch (version) {
      case _currentVersion:
        return LoggedInState(schoolEventMode: json['schoolEventMode']);
      default:
        return const LoggedInState();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    getIt<SharedPreferences>().setInt(_versionKey, _currentVersion);
    return {
      'schoolEventMode': schoolEventMode,
    };
  }
}

class AccountLockedState extends AuthState {
  static const Duration lockDurationMinutes = Duration(minutes: 16);

  static const Duration lockedCheckInterval = Duration(minutes: 1);

  const AccountLockedState({
    required this.lockDate,
    required this.minutesLeft,
  });

  AccountLockedState.initial()
      : minutesLeft = AccountLockedState.lockDurationMinutes.inMinutes,
        lockDate = DateTime.now().toIso8601String();

  final String lockDate;
  final int minutesLeft;

  AccountLockedState copyWith({
    String? lockDate,
    int? minutesLeft,
  }) {
    return AccountLockedState(
      lockDate: lockDate ?? this.lockDate,
      minutesLeft: minutesLeft ?? this.minutesLeft,
    );
  }

  @override
  List<Object?> get props => [lockDate, minutesLeft];

  factory AccountLockedState.fromJson(Map<String, dynamic> json) {
    return AccountLockedState(
      lockDate: json['lockDate'],
      minutesLeft: json['minutesLeft'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'lockDate': lockDate,
      'minutesLeft': minutesLeft,
    };
  }
}
