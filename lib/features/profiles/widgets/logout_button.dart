import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GivtFAButton(
      onTap: () {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvent.logOutPressed,
        );
        context.read<AuthCubit>().logout();
        context.read<ProfilesCubit>().clearProfiles();
        context.read<FlowsCubit>().resetFlow();

        context.goNamed(Pages.login.name);
      },
      text: 'Log out',
      leftIcon: Icon(
        FontAwesomeIcons.arrowLeft,
        size: 24,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
