import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/giving_option_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class GiveBottomSheet extends StatelessWidget {
  const GiveBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GiveOptionButton(
                context: context,
                size: size,
                text: 'Give with\na coin',
                imageLocation: 'assets/images/coin_action_button.svg',
                backgroundColor: AppTheme.lightYellow,
                secondColor: AppTheme.darkYellowText,
                onPressed: () {
                  context.pop();
                  context.pushNamed(Pages.scanNFC.name);
                },
              ),
              GiveOptionButton(
                context: context,
                size: size,
                text: 'Give with\na QR code',
                imageLocation: 'assets/images/qrcode_action_button.svg',
                backgroundColor: AppTheme.lightPurple,
                secondColor: AppTheme.darkPurpleText,
                onPressed: () {
                  context.pop();
                  AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvent.iWantToGiveToPressed,
                      eventProperties: {
                        'current_amount_in_wallet': context
                            .read<ProfilesCubit>()
                            .state
                            .activeProfile
                            .wallet
                            .balance,
                      });
                  context.pushNamed(Pages.camera.name);
                },
              ),
            ],
          ),
          SizedBox(height: size.width * 0.05),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.maxFinite, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: AppTheme.givt4KidsBlue, width: 2),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTheme.actionButtonStyle
                  .copyWith(color: AppTheme.givt4KidsBlue),
            ),
          ),
        ],
      ),
    );
  }
}
