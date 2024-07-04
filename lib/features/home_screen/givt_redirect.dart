import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/school_event_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_close_button.dart';
import 'package:go_router/go_router.dart';

class GivtRedirectScreen extends StatelessWidget {
  const GivtRedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Stack(
              children: [
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
                      SvgPicture.asset(
                        'assets/images/app_transition.svg',
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Good News!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'We\'ve combined our apps so your family only needs to use one app from now on.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'You can safely remove this app and use Givt to continue spreading generosity.',
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
