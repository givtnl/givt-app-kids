import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/flows.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/coin_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/wallet.dart';

import 'package:go_router/go_router.dart';

class ChooseAmountSliderScreen extends StatefulWidget {
  const ChooseAmountSliderScreen({
    Key? key,
    this.flow = Flows.main,
  }) : super(key: key);

  final Flows flow;

  @override
  State<ChooseAmountSliderScreen> createState() =>
      _ChooseAmountSliderScreenState();
}

class _ChooseAmountSliderScreenState extends State<ChooseAmountSliderScreen> {
  late final ProfilesCubit _profilesCubit;

  @override
  void initState() {
    _profilesCubit = context.read<ProfilesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final organisationDetailsState =
        context.read<OrganisationDetailsCubit>().state;

    final organisation = organisationDetailsState.organisation;
    final mediumId = organisationDetailsState.mediumId;

    return BlocProvider<CreateTransactionCubit>(
      create: (BuildContext context) =>
          CreateTransactionCubit(_profilesCubit, getIt()),
      child: BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
        listener: (context, state) {
          if (state is CreateTransactionErrorState) {
            log(state.errorMessage);
            SnackBarHelper.showMessage(context,
                text: 'Cannot create transaction. Please try again later.',
                isError: true);
          } else if (state is CreateTransactionSuccessState) {
            final parentGuid =
                (context.read<AuthCubit>().state as LoggedInState)
                    .session
                    .userGUID;
            context.read<ProfilesCubit>().fetchProfiles(parentGuid);

            context.pushReplacementNamed(
              widget.flow == Flows.main
                  ? Pages.success.name
                  : Pages.successCoin.name,
            );
          }
        },
        builder: (context, state) {
          final size = MediaQuery.sizeOf(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 85,
              automaticallyImplyLeading: false,
              leading: const GivtBackButton(),
              actions: [
                widget.flow == Flows.main ? const Wallet() : const CoinWidget(),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 75),
                    child: Row(
                      children: [
                        if (widget.flow == Flows.coin)
                          SvgPicture.asset('assets/images/church.svg'),
                        if (widget.flow == Flows.coin)
                          const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            organisation.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.defaultTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: const Text(
                      'How much would you like to give?',
                      style: TextStyle(
                        color: AppTheme.givt4KidsBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.05),
                    alignment: Alignment.center,
                    child: Text(
                      "\$${state.amount.round()}",
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.givt4KidsBlue,
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
                          activeColor: AppTheme.givt4KidsBlue,
                          inactiveColor: AppTheme.givt4KidsBlue.withAlpha(100),
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
                                'amount': value.roundToDouble()
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Text(
                                "\$0",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: AppTheme.defaultTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$${state.maxAmount.round()}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppTheme.defaultTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActoinButton(
              text: widget.flow == Flows.main ? 'Next' : 'Activate the coin',
              isLoading: state is CreateTransactionUploadingState,
              onPressed: state.amount == 0
                  ? null
                  : () async {
                      if (state is CreateTransactionUploadingState) {
                        return;
                      }
                      var transaction = Transaction(
                        userId: _profilesCubit.state.activeProfile.id,
                        mediumId: mediumId,
                        amount: state.amount,
                      );

                      context
                          .read<CreateTransactionCubit>()
                          .createTransaction(transaction: transaction);

                      AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.giveToThisGoalPressed,
                          eventProperties: {
                            'amount': state.amount,
                            'formatted_date': DateTime.now().toIso8601String(),
                            'goal_name': organisation.name,
                          });
                    },
            ),
          );
        },
      ),
    );
  }
}
