import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/back_home_button.dart';
import 'package:givt_app_kids/shared/widgets/switch_profile_success_button.dart';

import 'package:lottie/lottie.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';

class SuccessScreen extends StatefulWidget {
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
    final profiles = context.read<ProfilesCubit>().state.profiles;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppTheme.successBackgroundLightBlue,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppTheme.successBackgroundLightBlue,
        ),
      ),
      backgroundColor: AppTheme.successBackgroundLightBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Text(
                organisation.thankYou ?? "Thank you!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: AppTheme.defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Text(
                "Your parents can now approve \n your donation suggestion to \n ${organisation.name}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppTheme.defaultTextColor,
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
      floatingActionButton: profiles.length == 1
          ? const BackHomeButton()
          : const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BackHomeButton(
                  marging: EdgeInsets.only(left: 35, right: 35, bottom: 13),
                ),
                SwitchProfileSuccessButton(),
              ],
            ),
    );
  }
}
