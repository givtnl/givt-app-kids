// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;
import 'package:givt_app_kids/widgets/wallet.dart';
import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/models/organisation.dart';
import 'package:givt_app_kids/providers/profiles_provider.dart';

class ChooseAmountSliderScreen extends StatefulWidget {
  static const String routeName = "/choose-ammount-slider";

  const ChooseAmountSliderScreen({Key? key}) : super(key: key);

  @override
  _ChooseAmountSliderScreenState createState() =>
      _ChooseAmountSliderScreenState();
}

class _ChooseAmountSliderScreenState extends State<ChooseAmountSliderScreen> {
  double _selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    final organisation =
        ModalRoute.of(context)?.settings.arguments as Organisation;

    var profilesProvider = Provider.of<ProfilesProvider>(context);

    return SafeArea(
      child: Scaffold(
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
                      organisation.name,
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
                  "\$${_selectedAmount.round()}",
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
                      value: _selectedAmount,
                      min: 0,
                      max: profilesProvider.activeProfile!.balance,
                      activeColor: Color(0xFF54A1EE),
                      inactiveColor: Color(0xFFD9D9D9),
                      divisions:
                          profilesProvider.activeProfile!.balance.round(),
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedAmount = value;
                        });

                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.amountPressed,
                          eventProperties: {'amount': _selectedAmount},
                        );
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
                            "\$${profilesProvider.activeProfile!.balance.round()}",
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              onPressed: _selectedAmount == 0
                  ? null
                  : () async {
                      var profilesProvider =
                          Provider.of<ProfilesProvider>(context, listen: false);

                      var transaction = Transaction(
                        createdAt: DateTime.now().toIso8601String(),
                        amount: _selectedAmount,
                        parentGuid: profilesProvider.activeProfile!.guid,
                        destinationName: organisation.name,
                      );

                      profilesProvider.createTransaction(transaction);

                      AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.giveToThisGoalPressed,
                          eventProperties: {
                            'amount': _selectedAmount,
                            'formatted_date': transaction.createdAt,
                            'timestamp': DateTime.now().toIso8601String(),
                            'goal_name': organisation.name,
                          });

                      Navigator.of(context).pushNamed(SuccessScreen.routeName,
                          arguments: [organisation, transaction]);
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
      ),
    );
  }
}
