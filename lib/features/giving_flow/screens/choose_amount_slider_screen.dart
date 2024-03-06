import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/giving_flow/widgets/organisation_widget.dart';
import 'package:givt_app_kids/features/giving_flow/widgets/slider_widget.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/shared/widgets/coin_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/wallet.dart';

import 'package:go_router/go_router.dart';

class ChooseAmountSliderScreen extends StatelessWidget {
  const ChooseAmountSliderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    final organisationDetailsState =
        context.watch<OrganisationDetailsCubit>().state;
    final organisation = organisationDetailsState.organisation;
    final profilesCubit = context.read<ProfilesCubit>();
    final mediumId = organisationDetailsState.mediumId;

    return BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
      listener: (context, state) {
        if (state is CreateTransactionErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(context,
              text: 'Cannot create transaction. Please try again later.',
              isError: true);
        } else if (state is CreateTransactionSuccessState) {
          context.pushReplacementNamed(
            flow.isExhibition
                ? Pages.successExhibitionCoin.name
                : flow.isCoin
                    ? Pages.successCoin.name
                    : Pages.success.name,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: flow.isQRCode || flow.isRecommendation ? 85 : null,
            automaticallyImplyLeading: false,
            leading: const GivtBackButton(),
            actions: [_getAppBarAction(flow)],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      OrganisationWidget(organisation),
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
          floatingActionButton: GivtElevatedButton(
            isDisabled: state.amount == 0 ? true : false,
            text: (flow.isCoin || flow.isExhibition)
                ? 'Activate the coin'
                : flow.isRecommendation
                    ? 'Finish donation'
                    : 'Next',
            isLoading: state is CreateTransactionUploadingState,
            onTap: state.amount == 0
                ? null
                : () async {
                    if (state is CreateTransactionUploadingState) {
                      return;
                    }
                    context.read<ScanNfcCubit>().discardNFCScanner();
                    var transaction = Transaction(
                      userId: profilesCubit.state.activeProfile.id,
                      mediumId: mediumId,
                      amount: state.amount,
                    );

                    context
                        .read<CreateTransactionCubit>()
                        .createTransaction(transaction: transaction);

                    AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvent.giveToThisGoalPressed,
                        eventProperties: {
                          AnalyticsHelper.goalKey: organisation.name,
                          AnalyticsHelper.amountKey: state.amount,
                          AnalyticsHelper.walletAmountKey:
                              profilesCubit.state.activeProfile.wallet.balance,
                        });
                  },
          ),
        );
      },
    );
  }

  Widget _getAppBarAction(FlowsState flow) {
    if (flow.isQRCode || flow.isRecommendation) {
      return const Wallet();
    }
    if (flow.isCoin) {
      return const CoinWidget();
    }
    return const SizedBox();
  }
}
