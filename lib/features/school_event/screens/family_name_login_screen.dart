import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

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
          listener: (context, propfilesState) {
            if (propfilesState is ProfilesExternalErrorState) {
              _showErrorMessage();
            } else if (propfilesState is ProfilesUpdatedState &&
                propfilesState.activeProfile == Profile.empty()) {
              context
                  .read<ProfilesCubit>()
                  .fetchProfile(propfilesState.profiles[0].id);

              context.goNamed(Pages.schoolEventInfo.name);
            }
          },
          builder: (context, propfilesState) {
            return Scaffold(
              appBar: AppBar(
                leading: GivtBackButton(
                  onPressedForced: () => context.goNamed(Pages.login.name),
                ),
              ),
              body: authState is LoadingState ||
                      propfilesState is ProfilesLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: SizedBox.expand(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.1),
                              Text(
                                "Let's begin!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Enter your family name',
                                style: GoogleFonts.mulish(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height * 0.15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    setState(() {
                                      _familyName = value.trim();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: size.height * 0.10),
                            ],
                          ),
                        ),
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: authState is! LoadingState &&
                      propfilesState is! ProfilesLoadingState
                  ? GivtElevatedButton(
                      text: 'Next',
                      isDisabled:
                          _familyName.length < AuthCubit.familyNameMinLength,
                      onTap: () {
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
