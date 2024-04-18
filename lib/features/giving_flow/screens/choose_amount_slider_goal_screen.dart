import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/impact_groups/model/goal.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/giving_flow/widgets/family_goal_widget.dart';
import 'package:givt_app_kids/features/giving_flow/widgets/slider_widget.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';

import 'package:go_router/go_router.dart';

class ChooseAmountSliderGoalScreen extends StatelessWidget {
  const ChooseAmountSliderGoalScreen({required this.familyGoal, super.key});
  final Goal familyGoal;
  @override
  Widget build(BuildContext context) {
    final organisationDetailsState =
        context.watch<OrganisationDetailsCubit>().state;
    final profilesCubit = context.read<ProfilesCubit>();
    final organisation = organisationDetailsState.organisation;
    final mediumId = organisationDetailsState.mediumId;
    final amountLeftToGoal = familyGoal.goalAmount - familyGoal.amount;

    return BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
      listener: (context, state) async {
        if (state is CreateTransactionErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(context,
              text: 'Cannot create transaction. Please try again later.',
              isError: true);
        } else if (state is CreateTransactionSuccessState) {
          if (!context.mounted) {
            return;
          }

          context.pushReplacementNamed(Pages.successCoin.name,
              extra: familyGoal.isActive);
        }
      },
      builder: (context, state) {
        final amountLeftWithDonation =
            amountLeftToGoal - state.amount.round() > 0
                ? (amountLeftToGoal - state.amount.round()).toInt()
                : 0;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      FamilyGoalWidget(familyGoal, organisation),
                      const Spacer(),
                      Text("How much would you like to give?",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                SliderWidget(state.amount, state.maxAmount),
                const Spacer(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/goal_flag.svg',
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  if (amountLeftWithDonation > 0)
                    Text.rich(
                      TextSpan(
                        text: '\$$amountLeftWithDonation',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w700,
                            ),
                        children: [
                          TextSpan(
                            text: ' to complete the Family Goal',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.primary20,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  if (amountLeftWithDonation <= 0)
                    Text.rich(
                      TextSpan(
                        text: 'This donation will complete the\nFamily Goal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary20,
                            ),
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              GivtElevatedButton(
                isDisabled: state.amount == 0 ? true : false,
                text: 'Donate',
                isLoading: state is CreateTransactionUploadingState,
                onTap: state.amount == 0
                    ? null
                    : () async {
                        if (state is CreateTransactionUploadingState) {
                          return;
                        }
                        var transaction = Transaction(
                          userId: profilesCubit.state.activeProfile.id,
                          mediumId: mediumId,
                          amount: state.amount,
                          goalId: familyGoal.goalId,
                        );

                        context
                            .read<CreateTransactionCubit>()
                            .createTransaction(transaction: transaction);

                        AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvent.donateToThisFamilyGoalPressed,
                            eventProperties: {
                              AnalyticsHelper.goalKey: organisation.name,
                              AnalyticsHelper.amountKey: state.amount,
                              AnalyticsHelper.walletAmountKey: profilesCubit
                                  .state.activeProfile.wallet.balance,
                            });
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
