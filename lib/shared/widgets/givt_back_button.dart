import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flow_type.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';

import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class GivtBackButton extends StatelessWidget {
  const GivtBackButton({
    super.key,
    this.onPressedExt,
  });

  final void Function()? onPressedExt;

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    final isDeeplinkInApp =
        (!context.canPop() && flow.flowType == FlowType.inAppCoin);
    final isVisible = context.canPop() || isDeeplinkInApp;
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Opacity(
        opacity: isVisible ? 1 : 0,
        child: AbsorbPointer(
          absorbing: !isVisible,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.backButtonColor,
            child: IconButton(
              iconSize: 25,
              onPressed: () {
                onPressedExt?.call();

                AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.backButtonPressed);
                if (isDeeplinkInApp) {
                  context.goNamed(Pages.wallet.name);
                  return;
                }
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.givt4KidsBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
