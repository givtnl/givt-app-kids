import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({
    super.key,
    this.marging,
  });

  final EdgeInsets? marging;

  @override
  Widget build(BuildContext context) {
    return GivtFloatingActionButton(
      text: "Back to home",
      backgroundColor: AppTheme.givt4KidsYellow,
      foregroundColor: AppTheme.defaultTextColor,
      margin: marging,
      onPressed: () async {
        context.goNamed(Pages.wallet.name);
        context.read<FlowsCubit>().resetFlow();

        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.returnToHomePressed,
        );
      },
    );
  }
}
