import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

class SwitchProfileSuccessButton extends StatelessWidget {
  const SwitchProfileSuccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;

    return FloatingActoinButton(
      text: "Switch profile",
      backgroundColor: AppTheme.white85,
      foregroundColor: AppTheme.woodColor,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.network(
          context.read<ProfilesCubit>().state.activeProfile.pictureURL,
        ),
      ),
      onPressed: () async {
        if (flow.flowType == FlowType.deepLinkCoin) {
          context.read<FlowsCubit>().startInAppCoinFlow();
        }
        context.goNamed(Pages.profileSelection.name);

        AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.buttonPressed,
            eventProperties: {
              'button_name': 'Switch profile',
              'formatted_date': DateTime.now().toIso8601String(),
              'screen_name':
                  flow.isCoin ? Pages.successCoin.name : Pages.success.name,
            });
      },
    );
  }
}
