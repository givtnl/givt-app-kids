import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app_kids/features/family_goal_tracker/widgets/family_goal_tracker.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/profiles/widgets/give_bottomsheet.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/helpers/remote_config_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';
import 'package:givt_app_kids/shared/widgets/loading_progress_indicator.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
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
    // Check if school event flow is enabled
    final isSchoolEventFlowEnabled = RemoteConfigHelper.isFeatureEnabled(
        RemoteConfigFeatures.schoolEventFlow);
    final auth = context.read<AuthCubit>().state as LoggedInState;
    if (!isSchoolEventFlowEnabled && auth.isSchoolEvenMode) {
      RemoteConfigHelper.logoutHelper(context);
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
      final goalCubit = context.read<GoalTrackerCubit>();
      final authState = context.read<AuthCubit>().state as LoggedInState;
      var countdownAmount = 0.0;
      if (state is ProfilesCountdownState) {
        countdownAmount = state.amount;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(
            state.activeProfile.firstName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onPrimary,
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.solidPenToSquare,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                context.pushNamed(Pages.avatarSelection.name);
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvent.editAvatarIconClicked,
                );
              },
            )
          ],
        ),
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
                      const FamilyGoalTracker(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ActionTile(
                              isDisabled: !isGiveButtonActive,
                              text: "Give",
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
                            const SizedBox(width: 16),
                            ActionTile(
                              isDisabled: authState.isSchoolEvenMode,
                              text: "Find Charity",
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
                                context
                                    .pushNamed(Pages.recommendationStart.name);
                                AnalyticsHelper.logEvent(
                                    eventName: AmplitudeEvent
                                        .helpMeFindCharityPressed);
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: GivtFloatingActionButton(
          onTap: () {
            // Reset data + flow and go back to profile selection
            context.read<ProfilesCubit>().fetchAllProfiles();
            context.read<FlowsCubit>().resetFlow();

            context.pushReplacementNamed(Pages.profileSelection.name);
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvent.profileSwitchPressed,
            );
          },
          text: 'My Family',
          leftIcon: FontAwesomeIcons.arrowLeft,
        ),
      );
    });
  }
}
