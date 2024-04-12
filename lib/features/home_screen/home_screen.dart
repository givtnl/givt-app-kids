import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/goals/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/goals/pages/goal_screen.dart';
import 'package:givt_app_kids/features/history/history_logic/history_cubit.dart';
import 'package:givt_app_kids/features/history/history_screen.dart';
import 'package:givt_app_kids/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_screen.dart';
import 'package:givt_app_kids/features/home_screen/widgets/custom_navigation_bar.dart';
import 'package:givt_app_kids/features/home_screen/widgets/home_screen_app_bar.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeScreenAppBar(),
      bottomNavigationBar: CustomNavigationBar(
        index: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.selectionClick();
          context.read<NavigationCubit>().changePage(index);
          AnalyticsHelper.logEvent(
              eventName: AmplitudeEvent.navigationBarPressed,
              eventProperties: {
                'destination': NavigationDestinationData.values[index].name
              });
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOutQuart,
                switchOutCurve: Curves.easeInOutQuart,
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: getPage(state.activeDestination, context)),
          );
        },
      ),
    );
  }

  Widget getPage(NavigationDestinationData destination, BuildContext context) {
    final user = context.read<ProfilesCubit>().state.activeProfile;
    switch (destination) {
      case NavigationDestinationData.home:
        context.read<ProfilesCubit>().fetchActiveProfile();
        return const ProfileScreen();
      case NavigationDestinationData.groups:
        context.read<GoalTrackerCubit>().getGoal(user.id);
        return const GoalScreen();
      case NavigationDestinationData.myGivts:
        context.read<HistoryCubit>().fetchHistory(user.id);
        return const HistoryScreen();
    }
  }
}