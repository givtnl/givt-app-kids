import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';

import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/auth/dialogs/account_locked_dialog.dart';
import 'package:givt_app_kids/features/auth/widgets/download_givt_app_widget.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/remote_config_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
  void initState() {
    super.initState();

    if (context.read<AuthCubit>().state is AccountLockedState) {
      Future.delayed(Duration.zero, _showLockedDialog);
    }
  }

  Future<void>? _showingDialogFuture;

  Future<void> _showLockedDialog() async {
    if (_showingDialogFuture == null) {
      _showingDialogFuture = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AccountLockedDialog(),
      );
      await _showingDialogFuture;
      _showingDialogFuture = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final isSchoolEventFlowEnabled = RemoteConfigHelper.isFeatureEnabled(
        RemoteConfigFeatures.schoolEventFlow);

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
          if (context.read<FlowsCubit>().state.flowType !=
              FlowType.exhibition) {
            context.read<ProfilesCubit>().fetchAllProfiles();
            context.pushReplacementNamed(Pages.profileSelection.name);
          }
        } else if (state is AccountLockedState) {
          _showLockedDialog();
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.25,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          //let's hide exhibition flow for now
                          // onDoubleTap: () {
                          //   context.read<FlowsCubit>().startExhibitionFlow();
                          //   context.pushNamed(Pages.voucherCode.name);
                          // },
                          child: Text(
                            'Welcome',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppTheme.givt4KidsBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Ask your parent(s) to sign in\nwith their Givt account',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: (state is InputFieldErrorState &&
                                      state.emailErrorMessage.isNotEmpty)
                                  ? Theme.of(context).colorScheme.error
                                  : AppTheme.defaultTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        key: const ValueKey("email"),
                        //scrool down hotfix
                        scrollPadding: const EdgeInsets.only(bottom: 400),
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
                      const SizedBox(height: 15),
                      Text(
                        "Password",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: (state is InputFieldErrorState &&
                                          state.passwordErrorMessage
                                              .isNotEmpty ||
                                      (state is ExternalErrorState &&
                                          state.innerErrorType.isWrongPassword))
                                  ? Theme.of(context).colorScheme.error
                                  : AppTheme.defaultTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const ValueKey("password"),
                              //scrool down hotfix
                              scrollPadding: const EdgeInsets.only(bottom: 400),
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
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                      const SizedBox(height: 20),
                      if (state is ExternalErrorState &&
                          state.innerErrorType.isWrongPassword)
                        Text(
                          state.innerErrorType.errorMessage,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GivtElevatedButton(
                    text: 'Sign in',
                    isLoading: state is LoadingState,
                    isDisabled: !_isInputNotEmpty(),
                    onTap: () {
                      if (state is LoadingState) {
                        return;
                      }
                      
                       _login();
                    },
                  ),
                  const SizedBox(height: 24),
                  if (isSchoolEventFlowEnabled)
                    GivtElevatedSecondaryButton(
                      text: "I'm at WCA",
                      onTap: () {
                        AnalyticsHelper.logEvent(
                          eventName:
                              AmplitudeEvent.schoolEventFlowStartButtonClicked,
                        );
                        context.goNamed(Pages.familyNameLogin.name);
                      },
                    ),
                  if (!isSchoolEventFlowEnabled) const DownloadGivtAppWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
