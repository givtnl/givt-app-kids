// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/wallet_screen.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

import 'package:lottie/lottie.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';

class SuccessScreen extends StatefulWidget {
  static const String routeName = "/success-bloc";

  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Vibrator.tryVibratePattern();
  }

  @override
  Widget build(BuildContext context) {
    final organisation =
        context.read<OrganisationDetailsCubit>().state.organisation;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB9D7FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 40,
                  left: 40,
                  right: 40,
                ),
                child: Text(
                  organisation.thankYou ?? "Thank you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF3B3240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 40,
                  left: 40,
                  right: 40,
                ),
                child: Text(
                  "Your parents can now approve \n your donation suggestion to \n ${organisation.name}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF3B3240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Lottie.asset(
                "assets/lotties/donation.json",
                fit: BoxFit.fitWidth,
                width: double.infinity,
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
              onPressed: () async {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context)
                    .pushReplacementNamed(WalletScreenCubit.routeName);
                //TODO CLEAR ORGANISATION STATE
                context.read<OrganisationDetailsCubit>().clearOrganisation();
                await AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.continuePressed,
                    eventProperties: {'screen_name': SuccessScreen.routeName});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF2DF7F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Back to home",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF3B3240),
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
