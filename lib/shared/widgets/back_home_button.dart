import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GivtElevatedButton(
      text: "Back to home",
      leftIcon: Icon(
        FontAwesomeIcons.house,
        size: 24,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      onTap: () async {
        context.goNamed(Pages.wallet.name);
        context.read<FlowsCubit>().resetFlow();

        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.returnToHomePressed,
        );
      },
    );
  }
}
