import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/back_home_button.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/switch_profile_success_button.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccessCoinScreen extends StatefulWidget {
  const SuccessCoinScreen({required this.isGoal, super.key});
  final bool isGoal;
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
    final profilesState = context.read<ProfilesCubit>().state;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppTheme.secondary98,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: AppTheme.secondary98,
        ),
        backgroundColor: AppTheme.secondary98,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lotties/rays.json',
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                ),
              ),
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/box_success.svg',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                ),
              ),
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lotties/coin_drop_b.json',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                ),
              ),
              _buildSuccessText(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildFAB(profilesState.isOnlyChild));
  }

  Widget _buildSuccessText() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
        child: Column(
          children: [
            Text(
              widget.isGoal ? 'Well done!' : 'Activated!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.defaultTextColor,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.isGoal
                  ? 'You helped towards your family goal!'
                  : 'Drop your coin in\nthe giving box.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.defaultTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(bool isOnlyChild) {
    if (widget.isGoal) {
      return GivtElevatedButton(
        text: 'Done',
        onTap: () {
          context.goNamed(Pages.wallet.name);
          context.read<FlowsCubit>().resetFlow();

          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.returnToHomePressed,
          );
        },
      );
    }
    if (isOnlyChild) {
      return const BackHomeButton();
    }
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BackHomeButton(),
        SizedBox(height: 12),
        SwitchProfileSuccessButton(),
      ],
    );
  }
}
