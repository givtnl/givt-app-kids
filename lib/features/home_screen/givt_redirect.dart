import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/school_event_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_close_button.dart';
import 'package:go_router/go_router.dart';

class GivtRedirectScreen extends StatelessWidget {
  GivtRedirectScreen({super.key});

  final DateTime currentDate = DateTime.now();

  bool isPastDeadline() {
    final deadline = DateTime(2024, 8, 31);
    return currentDate.isAfter(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isPastDeadline(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Stack(
                children: [
                  if (!isPastDeadline())
                    Positioned(
                      right: 0,
                      child: GivtCloseButton(
                        onPressedForced: () {
                          context.goNamed(name(context));
                        },
                      ),
                    ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/see_you_givtapp.webp',
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'See you in the Givt app!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We\'ve combined our apps so your family only needs to use one app from now on.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Download the Givt app by August 31 and continue spreading generosity!',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String name(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final profiles = context.read<ProfilesCubit>().state;
    if (auth is LoggedInState) {
      final isSchoolEventUserLoggedOut =
          SchoolEventHelper.logoutSchoolEventUsers(context);
      if (isSchoolEventUserLoggedOut) {
        return Pages.login.name;
      }
      if (profiles.isProfileSelected) {
        return Pages.wallet.name;
      }
      context.read<ProfilesCubit>().fetchAllProfiles();
      return Pages.profileSelection.name;
    }
    return Pages.login.name;
  }
}
