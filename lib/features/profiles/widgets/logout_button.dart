import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF374A53),
      extendedPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      onPressed: () {
        AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.buttonPressed,
            eventProperties: {
              'button_name': 'Log out',
              'formatted_date': DateTime.now().toIso8601String(),
              'screen_name': Pages.profileSelection.name,
            });

        context.read<AuthCubit>().logout();
        context.read<ProfilesCubit>().clearProfiles();
        context.read<FlowsCubit>().resetFlow();

        context.goNamed(Pages.login.name);
      },
      label: const Text(
        'Log out',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      icon: const Icon(
        Icons.logout,
        size: 25,
      ),
    );
  }
}
