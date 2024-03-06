import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class FamilyNameLoginScreen extends StatefulWidget {
  const FamilyNameLoginScreen({super.key});

  @override
  State<FamilyNameLoginScreen> createState() => _FamilyNameLoginScreenState();
}

class _FamilyNameLoginScreenState extends State<FamilyNameLoginScreen> {
  String _familyName = '';

  void _showErrorMessage() {
    SnackBarHelper.showMessage(
      context,
      text: 'Cannot login with family name. Please try again later.',
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is ExternalErrorState) {
          _showErrorMessage();
        } else if (authState is LoggedInState) {
          context.read<ProfilesCubit>().fetchAllProfiles();
        }
      },
      builder: (context, authState) {
        return BlocConsumer<ProfilesCubit, ProfilesState>(
          listener: (context, profilesState) {
            if (profilesState is ProfilesExternalErrorState) {
              _showErrorMessage();
            } else if (profilesState is ProfilesUpdatedState &&
                profilesState.activeProfile == Profile.empty()) {
              context
                  .read<ProfilesCubit>()
                  .fetchProfile(profilesState.children[0].id);

              context.pushNamed(Pages.schoolEventInfo.name);
            }
          },
          builder: (context, profilesState) {
            return Scaffold(
              appBar: AppBar(
                leading: authState is LoadingState ||
                        profilesState is ProfilesLoadingState
                    ? const SizedBox()
                    : GivtBackButton(
                        onPressedForced: () =>
                            context.goNamed(Pages.login.name),
                      ),
                //default width (56) + left padding (24)
                leadingWidth: 56 + 24,
              ),
              body: authState is LoadingState ||
                      profilesState is ProfilesLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.184),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "What is your family's last name?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    key: const ValueKey("family"),
                                    //scrool down hotfix
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 400),
                                    decoration: const InputDecoration(
                                      fillColor: AppTheme.backButtonColor,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) => setState(() {
                                      _familyName = value.trim();
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: authState is! LoadingState &&
                      profilesState is! ProfilesLoadingState
                  ? GivtElevatedButton(
                      text: 'Continue',
                      isDisabled:
                          _familyName.length < AuthCubit.familyNameMinLength,
                      onTap: () {
                        AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvent
                                .schoolEventFlowLoginButtonClicked,
                            eventProperties: {
                              AnalyticsHelper.familyNameKey: _familyName,
                            });

                        context
                            .read<AuthCubit>()
                            .loginByFamilyName(_familyName);
                      },
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
