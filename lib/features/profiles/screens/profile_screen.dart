import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/profiles/widgets/give_bottomsheet.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/school_event_helper.dart';
import 'package:givt_app_kids/shared/widgets/loading_progress_indicator.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  bool isiPad = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    isIpadCheck().then((value) => setState(() {
          isiPad = value;
        }));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('state = $state');
    if (AppLifecycleState.resumed == state) {
      refresh();
    }
  }

  Future<void> refresh() async {
    final activeProfile = context.read<ProfilesCubit>().state.activeProfile;
    // Check user should be logged out
    final isSchoolEventUserLoggedOut =
        SchoolEventHelper.logoutSchoolEventUsers(context);
    if (isSchoolEventUserLoggedOut) {
      context.pushReplacementNamed(Pages.login.name);
      return;
    }
    // Execute tasks in parallel
    await Future.wait([
      context.read<ProfilesCubit>().fetchActiveProfile(true),
      context.read<GoalTrackerCubit>().getGoal(activeProfile.id)
    ]);
  }

  Future<bool> isIpadCheck() async {
    if (Platform.isAndroid) return false;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (deviceInfo.deviceInfo is IosDeviceInfo) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      if (info.model.isNotEmpty && info.model.toLowerCase().contains("ipad")) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      final isGiveButtonActive = state.activeProfile.wallet.balance > 0;
      final hasDonations = state.activeProfile.hasDonations;
      final authState = context.read<AuthCubit>().state as LoggedInState;
      final goalCubit = context.watch<GoalTrackerCubit>();

      var countdownAmount = 0.0;
      if (state is ProfilesCountdownState) {
        countdownAmount = state.amount;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: state is ProfilesLoadingState
            ? const LoadingProgressIndicator()
            : RefreshIndicator(
                onRefresh: refresh,
                child: Stack(
                  children: [
                    ListView(),
                    Column(children: [
                      WalletWidget(
                        balance: state.activeProfile.wallet.balance,
                        countdownAmount: countdownAmount,
                        hasDonations: hasDonations,
                        avatarUrl: state.activeProfile.pictureURL,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ActionTile(
                                isDisabled: !isGiveButtonActive,
                                titleBig: "Give",
                                iconPath: 'assets/images/give_tile.svg',
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                borderColor: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                                textColor:
                                    Theme.of(context).colorScheme.secondary,
                                onTap: () {
                                  AnalyticsHelper.logEvent(
                                      eventName:
                                          AmplitudeEvent.iWantToGivePressed,
                                      eventProperties: {
                                        AnalyticsHelper.walletAmountKey:
                                            state.activeProfile.wallet.balance,
                                      });
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    builder: (context) => GiveBottomSheet(
                                      familyGoal: goalCubit.state.currentGoal,
                                      isiPad: isiPad,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionTile(
                                isDisabled: authState.isSchoolEvenMode,
                                titleBig: "Find Charity",
                                iconPath: 'assets/images/find_tile.svg',
                                backgroundColor: AppTheme.primary98,
                                borderColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                textColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                onTap: () {
                                  context
                                      .read<FlowsCubit>()
                                      .startRecommendationFlow();
                                  context.pushNamed(
                                      Pages.recommendationStart.name);
                                  AnalyticsHelper.logEvent(
                                      eventName: AmplitudeEvent
                                          .helpMeFindCharityPressed);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
      );
    });
  }
}
