// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app_kids/features/create_transaction/models/transaction.dart';
import 'package:givt_app_kids/features/create_transaction/screens/success_screen.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/shared/widgets/wallet.dart';

import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;

class ChooseAmountSliderScreen extends StatefulWidget {
  static const String routeName = "/choose-ammount-slider-bloc";

  const ChooseAmountSliderScreen({Key? key}) : super(key: key);

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
    // final organisation =
    //     ModalRoute.of(context)?.settings.arguments as Organisation;

    return BlocProvider<CreateTransactionCubit>(
      create: (BuildContext context) =>
          CreateTransactionCubit(profilesCubit: _profilesCubit),
      child: SafeArea(
        child: BlocConsumer<CreateTransactionCubit, CreateTransactionState>(
          listener: (context, state) {
            log('auth state changed on $state');

            if (state is CreateTransactionErrorState) {
              log(state.errorMessage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Cannot create transaction. Please try again later.",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            } else if (state is CreateTransactionSuccessState) {
              Navigator.of(context).pushNamed(SuccessScreen.routeName);
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF1EAE2),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        custom_widgets.BackButton(),
                        Spacer(),
                        Wallet(),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 40, right: 40, top: 35),
                      child: Column(
                        children: [
                          Text(
                            'TODO: Org Name',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B3240),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Choose amount you want to give",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF3B3240),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 35),
                      alignment: Alignment.center,
                      child: Text(
                        "\$${state.amount.round()}",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF54A1EE),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Slider(
                            value: state.amount,
                            min: 0,
                            max: state.maxAmaount,
                            activeColor: Color(0xFF54A1EE),
                            inactiveColor: Color(0xFFD9D9D9),
                            divisions: state.maxAmaount.round(),
                            onChanged: (value) {
                              HapticFeedback.lightImpact();

                              context
                                  .read<CreateTransactionCubit>()
                                  .changeAmount(value);

                              // AnalyticsHelper.logEvent(
                              //   eventName: AmplitudeEvent.amountPressed,
                              //   eventProperties: {'amount': _selectedAmount},
                              // );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Text(
                                  "\$0",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF54A1EE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "\$${state.maxAmaount.round()}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF54A1EE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                    ),
                  ],
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
                    onPressed: state.amount == 0
                        ? null
                        : () async {
                            if (state is CreateTransactionUploadingState) {
                              return;
                            }

                            final authState = (context.read<AuthCubit>().state
                                as LoggedInState);

                            var transaction = Transaction(
                              createdAt: DateTime.now().toIso8601String(),
                              amount: state.amount,
                              parentGuid: authState.guid,
                              destinationName: 'TODO: Org Name',
                            );

                            context
                                .read<CreateTransactionCubit>()
                                .createTransaction(
                                    transaction: transaction,
                                    accessToken: authState.accessToken);

                            // AnalyticsHelper.logEvent(
                            //     eventName: AmplitudeEvent.giveToThisGoalPressed,
                            //     eventProperties: {
                            //       'amount': _selectedAmount,
                            //       'formatted_date': transaction.createdAt,
                            //       'timestamp': DateTime.now().toIso8601String(),
                            //       'goal_name': organisation.name,
                            //     });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF54A1EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: state is CreateTransactionUploadingState
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 9, horizontal: 25),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Text(
                              "Next",
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
            );
          },
        ),
      ),
    );
  }
}
