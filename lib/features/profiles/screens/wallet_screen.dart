import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/features/profiles/widgets/give_bottomsheet.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
    final parentGuid =
        (context.read<AuthCubit>().state as LoggedInState).session.userGUID;
    await context.read<ProfilesCubit>().fetchProfiles(parentGuid);
  }

  Future<String> _getAppIDAndVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final result =
        '${packageInfo.packageName} v${packageInfo.version}(${packageInfo.buildNumber})';
    log(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      final isGiveButtonActive = state.activeProfile.wallet.balance > 0;
      final hasDonations = state.activeProfile.lastDonationItem.amount > 0;

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
        ),
        body: Column(children: [
          WalletWidget(
            balance: state.activeProfile.wallet.balance,
            countdownAmount: countdownAmount,
            hasDonations: hasDonations,
          ),
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
                  backgroundColor: AppTheme.lightOrange,
                  borderColor: AppTheme.orange,
                  textColor: AppTheme.orangeText,
                  onTap: () {
                    AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvent.iWantToGivePressed,
                        eventProperties: {
                          AnalyticsHelper.walletAmountKey:
                              state.activeProfile.wallet.balance,
                        });
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      builder: (context) => const GiveBottomSheet(),
                    );
                  },
                ),
                const SizedBox(width: 16),
                ActionTile(
                  isDisabled: false,
                  text: "Find Charity",
                  iconPath: 'assets/images/find_tile.svg',
                  backgroundColor: AppTheme.lightGreen,
                  borderColor: AppTheme.greenBorder,
                  textColor: AppTheme.greenText,
                  onTap: () {
                    context.pushNamed(Pages.recommendationStart.name);
                    AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvent.helpMeFindCharityPressed);
                  },
                ),
              ],
            ),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: GivtFAButton(
          onTap: () {
            context.pushNamed(Pages.profileSelection.name);

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvent.profileSwitchPressed,
            );
          },
          text: state.activeProfile.firstName,
          leftIcon: Icon(
            FontAwesomeIcons.arrowLeft,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      );
    });
  }
}
