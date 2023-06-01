import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/auth/models/auth_request.dart';
import 'package:givt_app_kids/features/auth/repositoriy/auth_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const LoggedOutState()) {
    hydrate();
  }

  void logout() => emit(const LoggedOutState());

  Future<void> login(String email, String password) async {
    if (!_validateInputFields(email, password)) {
      return;
    }

    AnalyticsHelper.logEvent(
        eventName: AmplitudeEvent.loginPressed,
        eventProperties: {'email_address': email});

    emit(const LoadingState());
    final authRepository = AuthRepository();
    try {
      final response = await authRepository
          .login(AuthRequest(email: email, password: password));
      emit(LoggedInState(
        email: response.email,
        guid: response.guid,
        accessToken: response.accessToken,
      ));
    } catch (error) {
      emit(ExternalErrorState(errorMessage: error.toString()));
    }
  }

  bool _validateInputFields(String email, String password) {
    final emailErrorText =
        _isEmailValid(email) ? '' : 'Please enter a valid email address.';
    if (emailErrorText.isNotEmpty || !_isPasswordValid(password)) {
      emit(InputFieldErrorState(
          emailErrorMessage: emailErrorText,
          passwordErrorMessage: _getPasswordErrorMessage(password) ?? ''));
      return false;
    } else {
      return true;
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.trim());
  }

  bool _isPasswordValid(String passwordText) {
    return _getPasswordErrorMessage(passwordText) == null;
  }

  String? _getPasswordErrorMessage(String passwordText) {
    final password = passwordText.trim();
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 7) {
      return 'Password must be at least 7 characters long';
    }
    if (password.contains(RegExp(r'[0-9]')) == false) {
      return 'Password must contain a digit';
    }
    if (password.contains(RegExp(r'[A-Z]')) == false) {
      return 'Password must contain an upper case character';
    }
    if (password.length > 100) {
      return 'Password cannot contain more than 100 characters';
    }
    return null;
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final instanceType = json['instanceType'];
    final instance = jsonDecode(json['instance']);

    log("fromJSON: $json");

    // if (instanceType == const LoggedOutState().runtimeType.toString()) {
    //   return const LoggedOutState();
    // } else if (instanceType == const LoadingState().runtimeType.toString()) {
    //   return const LoadingState();
    // } else if (instanceType ==
    //     const InputFieldErrorState().runtimeType.toString()) {
    //   return InputFieldErrorState.fromJson(instance);
    // } else if (instanceType ==
    //     const ExternalErrorState().runtimeType.toString()) {
    //   return ExternalErrorState.fromJson(instance);
    // } else
    if (instanceType == const LoggedInState().runtimeType.toString()) {
      return LoggedInState.fromJson(instance);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    final result = {
      'instanceType': state.runtimeType.toString(),
      'instance': jsonEncode(state.toJson()),
    };
    log("toJSON: $result");
    return result;
  }
}
