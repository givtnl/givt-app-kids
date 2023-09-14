// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_rays_animated_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_animation_button.dart';
import 'package:go_router/go_router.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';

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
    return Scaffold(
      backgroundColor: Color(0xFFB9D7FF),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: CoinRaysAnimatedWidget(),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 150),
              child: Column(
                children: [
                  Text(
                    "Activated!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "It’s ready for the\ncollection now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/coin_activated_success.svg',
                width: 150,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingAnimationButton(
        text: "Back to home",
        backgroundColor: const Color(0xFFF2DF7F),
        foregroundColor: const Color(0xFF3B3240),
        onPressed: () async {
          context.pushReplacementNamed(Pages.wallet.name);
          AnalyticsHelper.logEvent(
              eventName: AmplitudeEvent.buttonPressed,
              eventProperties: {
                'button_name': 'Back to home',
                'formatted_date': DateTime.now().toIso8601String(),
                'screen_name': Pages.successCoin.name,
              });
        },
      ),
    );
  }
}
