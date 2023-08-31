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
  const ExternalErrorState({this.errorMessage = ''});

  final String errorMessage;
  @override
  List<Object?> get props => [errorMessage];

  factory ExternalErrorState.fromJson(Map<String, dynamic> json) {
    return ExternalErrorState(
      errorMessage: json['errorMessage'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'errorMessage': errorMessage,
    };
  }
}

class LoggedInState extends AuthState {
  const LoggedInState({
    this.session = const Session.empty(),
  });

  final Session session;

  factory LoggedInState.fromJson(Map<String, dynamic> json) {
    return LoggedInState(
      session: Session.fromJson(json),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return session.toJson();
  }
}
