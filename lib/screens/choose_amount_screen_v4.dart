// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_extended_screen.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/widgets/wallet.dart';
import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;
import 'package:givt_app_kids/providers/profiles_provider.dart';

import '../models/organisation.dart';

class ChooseAmountScreenV4 extends StatefulWidget {
  static const String routeName = "/choose-ammount-v4";

  const ChooseAmountScreenV4({Key? key}) : super(key: key);

  @override
  State<ChooseAmountScreenV4> createState() => _ChooseAmountScreenStateV4();
}

class _ChooseAmountScreenStateV4 extends State<ChooseAmountScreenV4> {
  final List<double> _amountOptions = [2, 5, 7];

  final double addScrollThreshold = 500;

  int _currentAmountIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1EAE2),
        body: Container(
            child: mediaQuery.size.height < addScrollThreshold
                ? SingleChildScrollView(
                    child: _createMainLayout(context, true),
                  )
                : _createMainLayout(context, false)),
      ),
    );
  }

  Widget _createMainLayout(BuildContext context, bool addScroll) {
    final organisation =
        ModalRoute.of(context)?.settings.arguments as Organisation;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                custom_widgets.BackButton(),
                Spacer(),
                Wallet(),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 30),
              child: Text(
                "Presbyterian Church Tulsa",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3240),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _createPickOptions(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ChooseAmountExtendedScreen.routeName);
                  },
                  child: Text(
                    "enter a different amount",
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        if (!addScroll) Spacer(),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 30,
            bottom: 30,
            left: 50,
            right: 50,
          ),
          child: ElevatedButton(
            onPressed: _currentAmountIndex == -1
                ? null
                : () async {
                    var profilesProvider =
                        Provider.of<ProfilesProvider>(context, listen: false);

                    var giveAmount = _amountOptions[_currentAmountIndex];
                    if (giveAmount > profilesProvider.activeProfile!.balance) {
                      giveAmount = profilesProvider.activeProfile!.balance;
                    }
                    var transaction = Transaction(
                      createdAt: DateTime.now().toIso8601String(),
                      amount: giveAmount,
                      parentGuid: profilesProvider.activeProfile!.guid,
                      destinationName: organisation.name,
                    );

                    profilesProvider.createTransaction(transaction);

                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvent.giveToThisGoalPressed,
                      eventProperties: {
                        "amount": giveAmount,
                        "formatted_date": transaction.createdAt,
                        "goal_name": organisation.name,
                      },
                    );

                    Navigator.of(context).pushNamed(SuccessScreen.routeName,
                        arguments: transaction);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF54A1EE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Text(
                "Give to this goal",
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
    );
  }

  List<Widget> _createPickOptions() {
    var profilesProvider = Provider.of<ProfilesProvider>(context, listen: true);

    const double pickItemSize = 65;

    List<Widget> result = [];

    for (var i = 0; i < _amountOptions.length; i++) {
      double currentOptionAmount;

      bool noMoreMoney = false;
      if (profilesProvider.activeProfile!.balance <= _amountOptions[i]) {
        currentOptionAmount = profilesProvider.activeProfile!.balance;
        noMoreMoney = true;
      } else {
        currentOptionAmount = _amountOptions[i];
      }

      String currentOptionAmountString = currentOptionAmount.toStringAsFixed(0);
      if (noMoreMoney && currentOptionAmount.toString().split(".").length > 1) {
        currentOptionAmountString = currentOptionAmount.toStringAsFixed(1);
      }

      result.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if (_currentAmountIndex == i) {
                _currentAmountIndex = -1;
              } else {
                _currentAmountIndex = i;
                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.amountPressed,
                    eventProperties: {
                      'amount': currentOptionAmount,
                    });
              }
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: pickItemSize,
            height: pickItemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: i == _currentAmountIndex
                  ? Color(0xFF54A1EE)
                  : Color(0xFFBFDBFC),
            ),
            child: Text(
              "\$$currentOptionAmountString",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    i == _currentAmountIndex ? Colors.white : Color(0xFF3B3240),
              ),
            ),
          ),
        ),
      );
      if (noMoreMoney) {
        break;
      }
    }

    return result;
  }
}
