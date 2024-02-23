import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';

import 'package:go_router/go_router.dart';

class ChooseAmountSliderGoalScreen extends StatelessWidget {
  const ChooseAmountSliderGoalScreen({required this.familyGoal, super.key});
  final FamilyGoal familyGoal;
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
        final size = MediaQuery.sizeOf(context);
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (organisation.logoLink != null)
                        Container(
                          width: size.width * .22,
                          height: size.width * .22,
                          padding: EdgeInsets.only(right: size.width * .03),
                          child: Image.network(
                            organisation.logoLink!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      SizedBox(
                        width: size.width * .68,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              familyGoal.orgName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppTheme.primary20),
                            ),
                            Text(
                              'Family goal: \$${familyGoal.goalAmount}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: Text(
                      'How much would you like to give?',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 38),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.035),
                    alignment: Alignment.center,
                    child: Text(
                      "\$${state.amount.round()}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primary20,
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Slider(
                          value: state.amount,
                          min: 0,
                          max: state.maxAmount,
                          activeColor:
                              Theme.of(context).colorScheme.onInverseSurface,
                          inactiveColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          divisions: state.maxAmount.round(),
                          onChanged: (value) {
                            HapticFeedback.lightImpact();

                            context
                                .read<CreateTransactionCubit>()
                                .changeAmount(value);
                          },
                          onChangeEnd: (value) {
                            AnalyticsHelper.logEvent(
                              eventName: AmplitudeEvent.amountPressed,
                              eventProperties: {
                                AnalyticsHelper.amountKey: value.roundToDouble()
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                "\$0",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const Spacer(),
                              Text(
                                "\$${state.maxAmount.round()}",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
              SizedBox(height: 20),
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
