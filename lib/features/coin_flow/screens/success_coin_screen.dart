import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

import 'package:givt_app_kids/helpers/vibrator.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFB9D7FF),
      body: Stack(
        children: [
          // const Positioned.fill(
          //   child: Center(
          //     child: CoinRaysAnimatedWidget(),
          //   ),
          // ),
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 70),
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
                    "Drop your coin wherever your\nchurch collects money.",
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
          // Positioned.fill(
          //   child: Center(
          //     child: SvgPicture.asset(
          //       'assets/images/coin_activated_success.svg',
          //       width: 150,
          //     ),
          //   ),
          // ),

          Positioned.fill(
            child: Lottie.asset(
              "assets/lotties/coin_success_2.json",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActoinButton(
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
