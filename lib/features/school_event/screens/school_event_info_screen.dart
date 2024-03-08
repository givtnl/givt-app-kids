import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/school_event/widgets/school_event_coin_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class SchoolEventInfoScreen extends StatelessWidget {
  const SchoolEventInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final activeProfile = context.watch<ProfilesCubit>().state.activeProfile;

    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, profilesState) {
        if (profilesState is ProfilesExternalErrorState) {
          SnackBarHelper.showMessage(
            context,
            text:
                'Cannot load profile. Please try again later. ${profilesState.errorMessage}',
            isError: true,
          );
        }
      },
      builder: (context, profilesState) {
        return Scaffold(
          appBar: AppBar(
            leading: profilesState is ProfilesLoadingState
                ? const SizedBox()
                : GivtBackButton(
                    onPressedExt: () {
                      context.read<AuthCubit>().logout();
                      context.read<ProfilesCubit>().clearProfiles();
                    },
                  ),
            //default width (56) + left padding (24)
            leadingWidth: 56 + 24,
          ),
          body: profilesState is ProfilesLoadingState
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: size.height * 0.184,
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Hi ${activeProfile.firstName}!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.primary20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Thanks to the generous support of the Bank of Oklahoma, we are delighted to give you:',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppTheme.primary20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          SchoolEventCoinWidget(
                            amount: activeProfile.wallet.balance,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'to contribute to the Impact Groups that are making a difference for the charities here tonight.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.primary20,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: GivtElevatedButton(
            text: 'Continue',
            isDisabled: profilesState is ProfilesLoadingState,
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.schoolEventFlowConfirmButtonClicked,
              );

              context.goNamed(Pages.wallet.name);
            },
          ),
        );
      },
    );
  }
}
