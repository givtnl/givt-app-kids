import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfilesCubit>();
    final navigation = context.watch<NavigationCubit>();
    return AppBar(
      title: Text(
        navigation.state.activeDestination.appBarTitle.isEmpty
            ? profiles.state.activeProfile.firstName
            : navigation.state.activeDestination.appBarTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      actions: [
        if (navigation.state.activeDestination ==
            NavigationDestinationData.home)
          IconButton(
            icon: switchProfilesIcon(),
            onPressed: () {
              profiles.fetchAllProfiles();
              context.read<FlowsCubit>().resetFlow();

              context.pushReplacementNamed(Pages.profileSelection.name);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.profileSwitchPressed,
              );
            },
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
