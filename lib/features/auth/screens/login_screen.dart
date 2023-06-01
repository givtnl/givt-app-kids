// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';

import 'package:flutter_svg/svg.dart';

class LoginBlocScreen extends StatefulWidget {
  static const String routeName = "/login-bloc";

  const LoginBlocScreen({Key? key}) : super(key: key);

  @override
  State<LoginBlocScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginBlocScreen> {
  String _email = "";
  String _password = "";

  bool _isPasswordVisible = false;

  Future<void> _login() async {
    context.read<AuthCubit>().login(_email, _password);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          log('auth state changed on $state');
          if (state is ExternalErrorState) {
            log(state.errorMessage);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Cannot login. Please try again later.",
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          } else if (state is LoggedInState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Logged in with token: ${state.accessToken}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: const Color(0xFFEEEDE4),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Color(0xFF54A1EE),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      height: 60,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Color(0xFF3B3240),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFBFDBFC),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: TextField(
                          key: ValueKey("email"),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorText: state is InputFieldErrorState
                                ? state.emailErrorMessage
                                : null,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => _email = value,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFF3B3240),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFBFDBFC),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: ValueKey("password"),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  errorText: state is InputFieldErrorState
                                      ? state.passwordErrorMessage
                                      : null,
                                ),
                                obscureText: !_isPasswordVisible,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (value) => _password = value,
                                onSubmitted: (value) => _login(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: SvgPicture.asset(
                                  _isPasswordVisible
                                      ? "assets/images/password_hide.svg"
                                      : "assets/images/password_show.svg",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 55,
            margin: const EdgeInsets.only(bottom: 25),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (state is LoadingState) {
                    return;
                  }

                  _login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE28D4D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: state is LoadingState
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 25),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Color(0xFF54A1EE),
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
