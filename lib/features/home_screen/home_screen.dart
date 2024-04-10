import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/goal_screen.dart';
import 'package:givt_app_kids/features/history/history_screen.dart';
import 'package:givt_app_kids/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_screen.dart';
import 'package:givt_app_kids/features/home_screen/widgets/custom_navigation_bar.dart';
import 'package:givt_app_kids/features/home_screen/widgets/home_screen_app_bar.dart';

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
            log('currentPageIndex = $currentPageIndex');
            context.read<NavigationCubit>().changePage(index);
          });
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: getPage(state.activeDestination)),
          );
        },
      ),
    );
  }

  Widget getPage(NavigationDestinationData destination) {
    switch (destination) {
      case NavigationDestinationData.home:
        return const ProfileScreen();
      case NavigationDestinationData.groups:
        return const GoalScreen();
      case NavigationDestinationData.myGivts:
        return const HistoryScreen();
    }
  }
}
