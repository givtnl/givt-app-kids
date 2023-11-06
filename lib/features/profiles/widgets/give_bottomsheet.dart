import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class GiveBottomsheet extends StatelessWidget {
  const GiveBottomsheet({super.key});

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
              givingOptionButton(
                context,
                size,
                'Give with\na coin',
                'assets/images/coin_action_button.svg',
                AppTheme.lightYellow,
                AppTheme.darkYellowText,
                () => context.pushNamed(Pages.scanNFC.name),
              ),
              givingOptionButton(
                context,
                size,
                'Give with\na QR code',
                'assets/images/qrcode_action_button.svg',
                AppTheme.lightPurple,
                AppTheme.darkPurpleText,
                () {
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

  Widget givingOptionButton(
          BuildContext context,
          Size size,
          String text,
          String imageLocation,
          Color backgroundColor,
          Color secondColor,
          VoidCallback onPressed) =>
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: secondColor.withOpacity(0.25),
              width: 2,
            ),
          ),
        ),
        child: SizedBox(
          width: size.width * 0.5 - size.width * 0.15,
          height: size.width * 0.5 - size.width * 0.15,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(imageLocation),
              const SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppTheme.actionButtonStyle.copyWith(
                  fontSize: 20,
                  color: secondColor,
                ),
              ),
            ],
          ),
        ),
      );
}
