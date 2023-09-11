import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/qr_scanner/presentation/camera_screen.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class QrGiveButton extends StatelessWidget {
  const QrGiveButton({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isActive
          ? () {
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

              Navigator.of(context).pushNamed(CameraScreen.routeName);
            }
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 60),
        backgroundColor: const Color(0xFFE28D4D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: SvgPicture.asset("assets/images/qr_icon.svg"),
      label: const Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 10,
        ),
        child: Text(
          "I want to give",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF1EAE2),
          ),
        ),
      ),
    );
  }
}
