part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState({
    required this.email,
    required this.guid,
    required this.accessToken,
  });

  final String email;
  final String guid;
  final String accessToken;

  @override
  List<Object?> get props => [email, guid, accessToken];
}

class LoggedOutState extends AuthState {
  const LoggedOutState() : super(email: '', guid: '', accessToken: '');
}

class LoadingState extends AuthState {
  const LoadingState() : super(email: '', guid: '', accessToken: '');
}

class InputFieldErrorState extends AuthState {
  const InputFieldErrorState({
    required this.emailErrorMessage,
    required this.passwordErrorMessage,
  }) : super(email: '', guid: '', accessToken: '');

  final String emailErrorMessage;
  final String passwordErrorMessage;

  @override
  List<Object?> get props =>
      [email, guid, accessToken, emailErrorMessage, passwordErrorMessage];
}

class ExternalErrorState extends AuthState {
  const ExternalErrorState({
    required this.errorMessage,
  }) : super(email: '', guid: '', accessToken: '');

  final String errorMessage;
  @override
  List<Object?> get props => [email, guid, accessToken, errorMessage];
}

class LoggedInState extends AuthState {
  const LoggedInState({
    required super.email,
    required super.guid,
    required super.accessToken,
  });
}
