import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/find_charity_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/give_bottomsheet.dart';
import 'package:givt_app_kids/features/profiles/widgets/history_header.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/donation_item_widget.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_frame.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
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
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      final isGiveButtonActive = state.activeProfile.wallet.balance > 0;
      final hasDonations = state.activeProfile.lastDonationItem.amount > 0;

      var countdownAmount = 0.0;
      if (state is ProfilesCountdownState) {
        countdownAmount = state.amount;
      }

      return WalletFrame(
        body: RefreshIndicator(
          color: const Color(0xFF54A1EE),
          onRefresh: refresh,
          child: Stack(
            children: [
              ListView(),
              Column(
                key: UniqueKey(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Heading2(text: state.activeProfile.firstName),
                  GestureDetector(
                    onLongPress: () =>
                        context.pushReplacementNamed(Pages.searchForCoin.name),
                    onDoubleTap: () async {
                      final appInfoString = await _getAppIDAndVersion();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              appInfoString,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: WalletWidget(
                      balance: state.activeProfile.wallet.balance,
                      countdownAmount: countdownAmount,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  hasDonations ? const HistoryHeader() : const SizedBox(),
                  hasDonations
                      ? GestureDetector(
                          onTap: () {
                            context.pushNamed(Pages.history.name);
                            AnalyticsHelper.logEvent(
                              eventName:
                                  AmplitudeEvent.seeDonationHistoryPressed,
                            );
                          },
                          child: DonationItemWidget(
                            donation: state.activeProfile.lastDonationItem,
                          ),
                        )
                      : const SizedBox(),
                  const Spacer(),
                  isGiveButtonActive
                      ? FloatingActoinButton(
                          text: "I want to give",
                          padded: false,
                          backgroundColor: AppTheme.givt4KidsYellow,
                          foregroundColor: AppTheme.defaultTextColor,
                          onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            builder: (context) => const GiveBottomSheet(),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileSwitchButton(
                          name: state.activeProfile.firstName,
                          onClicked: () {
                            context.pushNamed(Pages.profileSelection.name);

                            AnalyticsHelper.logEvent(
                              eventName: AmplitudeEvent.profileSwitchPressed,
                            );
                          }),
                      const FindCharityButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
