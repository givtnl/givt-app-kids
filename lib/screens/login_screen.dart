// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//import 'dart:developer' as dev;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import 'package:givt_app_kids/providers/auth_provider.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController _textController = TextEditingController();

  String _email = "";
  String _password = "";

  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<void> _saveForm() async {
    var isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }
    _formKey.currentState?.save();

    try {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<AuthProvider>(context, listen: false)
          .login(email: _email, password: _password);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot login. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Form(
                  key: _formKey,
                  child: Column(
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
                        child: TextFormField(
                          key: ValueKey("email"),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            var email = value?.trim() ?? "";
                            if (!_isEmailValid(email)) {
                              return "Please enter a valid email address.";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
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
                              child: TextFormField(
                                key: ValueKey("password"),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                obscureText: !_isPasswordVisible,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  var password = value?.trim() ?? "";
                                  if (password.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (password.length < 7) {
                                    return 'Password must be at least 7 characters long';
                                  }
                                  if (password.contains(RegExp(r'[0-9]')) ==
                                      false) {
                                    return 'Password must contain a digit';
                                  }
                                  if (password.contains(RegExp(r'[A-Z]')) ==
                                      false) {
                                    return 'Password must contain an upper case character';
                                  }
                                  if (password.length > 100) {
                                    return 'Password cannot contain more than 100 characters';
                                  }
                                  _password = password;
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
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
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    height: 180,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isLoading) {
                        return;
                      }
                      AnalyticsHelper.logButtonPressedEvent(
                          "Log in", LoginScreen.routeName);

                      _saveForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE28D4D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isLoading
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 9, horizontal: 25),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Color(0xFF54A1EE),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 25),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
