import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/back_home_button.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';
import 'package:givt_app_kids/shared/widgets/switch_profile_success_button.dart';
import 'package:lottie/lottie.dart';

class SuccessCoinScreen extends StatefulWidget {
  const SuccessCoinScreen({Key? key}) : super(key: key);

  @override
  State<SuccessCoinScreen> createState() => _SuccessCoinScreenState();
}

class _SuccessCoinScreenState extends State<SuccessCoinScreen> {
  @override
  void initState() {
    super.initState();

    Vibrator.tryVibratePattern();
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.read<ProfilesCubit>().state.profiles;

    return Scaffold(
      backgroundColor: AppTheme.successBackgroundLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                "assets/lotties/coin_success_2.json",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
              ),
            ),
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: 0, right: 0, top: 70),
                child: Column(
                  children: [
                    Text(
                      "Activated!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.defaultTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Drop your coin wherever your\nchurch collects money.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.defaultTextColor,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          (profiles.where((profile) => profile.type.contains('Child')).length ==
                  1)
              ? const BackHomeButton()
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackHomeButton(),
                    SizedBox(height: 12),
                    SwitchProfileSuccessButton(),
                  ],
                ),
    );
  }
}
