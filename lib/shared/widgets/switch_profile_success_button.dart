import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class SwitchProfileSuccessButton extends StatelessWidget {
  const SwitchProfileSuccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final flowsCubit = context.read<FlowsCubit>();
    final profilesCubit = context.read<ProfilesCubit>();

    return GivtElevatedButton(
      text: "Switch profile",
      isSecondary: true,
      leadingImage: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SvgPicture.network(
          profilesCubit.state.activeProfile.pictureURL,
          height: 32,
          width: 32,
        ),
      ),
      onTap: () async {
        if (flowsCubit.state.flowType == FlowType.deepLinkCoin) {
          flowsCubit.startInAppCoinFlow();
        }
        context.goNamed(Pages.profileSelection.name);
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.profileSwitchPressed,
        );
      },
    );
  }
}
