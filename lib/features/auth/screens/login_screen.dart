import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';

import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";

  bool _isPasswordVisible = false;

  Future<void> _login() async {
    context.read<AuthCubit>().login(_email, _password);
  }

  bool _isInputNotEmpty() {
    return _email.isNotEmpty && _password.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        log('auth state changed on $state');
        if (state is ExternalErrorState) {
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot login. Please try again later.',
            isError: true,
          );
        } else if (state is LoggedInState) {
          context.pushReplacementNamed(Pages.profileSelection.name);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.33,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.givt4KidsBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Ask your parent(s) to sign in\nwith their Givt account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.defaultTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: (state is InputFieldErrorState &&
                                    state.emailErrorMessage.isNotEmpty)
                                ? AppTheme.givt4KidsRed
                                : AppTheme.defaultTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        key: const ValueKey("email"),
                        decoration: InputDecoration(
                          fillColor: AppTheme.backButtonColor,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none,
                          ),
                          errorText: (state is InputFieldErrorState &&
                                  state.emailErrorMessage.isNotEmpty)
                              ? state.emailErrorMessage
                              : null,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => setState(() {
                          _email = value;
                        }),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: (state is InputFieldErrorState &&
                                    state.passwordErrorMessage.isNotEmpty)
                                ? AppTheme.givt4KidsRed
                                : AppTheme.defaultTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const ValueKey("password"),
                              decoration: InputDecoration(
                                suffixIconConstraints: const BoxConstraints(
                                    maxWidth: 50, maxHeight: 50),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset(
                                      _isPasswordVisible
                                          ? "assets/images/password_hide.svg"
                                          : "assets/images/password_show.svg",
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ),
                                fillColor: AppTheme.backButtonColor,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: (state is InputFieldErrorState &&
                                        state.passwordErrorMessage.isNotEmpty)
                                    ? state.passwordErrorMessage
                                    : null,
                              ),
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (value) => setState(() {
                                _password = value;
                              }),
                              onSubmitted: (value) => _login(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 130),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActoinButton(
          text: 'Sign in',
          isLoading: state is LoadingState,
          onPressed: _isInputNotEmpty()
              ? () {
                  if (state is LoadingState) {
                    return;
                  }

                  _login();
                }
              : null,
        ),
      ),
    );
  }
}
