import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/core/exceptions/givt_server_exception.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:givt_app_kids/features/auth/cubit/givt_inner_error_type.dart';
import 'package:givt_app_kids/features/auth/models/auth_request.dart';
import 'package:givt_app_kids/features/auth/models/session.dart';
import 'package:givt_app_kids/features/auth/repositories/auth_repository.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  static const int voucherCodeLength = 6;

  AuthCubit(this._authRepositoy) : super(const LoggedOutState()) {
    hydrate();
    _handleLockedAccount();
  }

  final AuthRepository _authRepositoy;

  void logout() => emit(const LoggedOutState());

  Future<void> login(String email, String password) async {
    if (!_validateInputFields(email, password)) {
      return;
    }

    AnalyticsHelper.logEvent(
        eventName: AmplitudeEvent.loginPressed,
        eventProperties: {'email_address': email});

    emit(const LoadingState());
    try {
      final response = await _authRepositoy.login(
        AuthRequest.email(email: email, password: password),
      );
      emit(LoggedInState(session: response));
    } on GivtServerException catch (error) {
      final errorState = ExternalErrorState.fromJson(error.body!);
      if (errorState.innerErrorType == GivtInnerErrorType.wrongPasswordLocked) {
        emit(AccountLockedState.initial());
        _handleLockedAccount();
        AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.accountLocked,
            eventProperties: {'email_address': email});
      } else {
        emit(errorState);
      }
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error("Login failed: $error", methodName: stackTrace.toString());
      emit(ExternalErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> loginByVoucherCode(String voucherCode) async {
    if (!_isVoucherCodeValid(voucherCode)) {
      return;
    }

    emit(const LoadingState());
    try {
      final response = await _authRepositoy.login(
        AuthRequest.voucher(voucherCode: voucherCode),
      );

      emit(LoggedInState(session: response));
    } catch (error, stackTrace) {
      LoggingInfo.instance.warning("Login by voucher code failed: $error",
          methodName: stackTrace.toString());
      emit(ExternalErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _handleLockedAccount() async {
    if (state is AccountLockedState) {
      final lockedState = (state as AccountLockedState);

      final lockedDate = DateTime.parse(lockedState.lockDate);
      final unlockDate = lockedDate.add(AccountLockedState.lockDurationMinutes);
      final now = DateTime.now();

      Duration difference = unlockDate.difference(now);
      final minutesLeft = difference.inMinutes;

      emit(lockedState.copyWith(minutesLeft: minutesLeft));

      if (minutesLeft > 0) {
        await Future.delayed(
            AccountLockedState.lockedCheckInterval, _handleLockedAccount);
      }
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

  bool _isVoucherCodeValid(String voucherCode) {
    return voucherCode.length == voucherCodeLength;
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

    if (instanceType == LoggedInState().runtimeType.toString()) {
      return LoggedInState.fromJson(instance);
    } else if (instanceType ==
        const ExternalErrorState().runtimeType.toString()) {
      return ExternalErrorState.fromJson(instance);
    } else if (instanceType ==
        AccountLockedState.initial().runtimeType.toString()) {
      return AccountLockedState.fromJson(instance);
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

    return result;
  }
}
