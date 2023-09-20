import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/pending_approval_widget.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/shared/widgets/qr_give_button.dart';
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

  Future<String> _getAppID() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    log("App Name : $appName, App Package Name: $packageName, App Version: $version, App build Number: $buildNumber");
    return packageName;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      final isPending = state.activeProfile.wallet.pending > 0.0;
      final isGiveButtonActive = state.activeProfile.wallet.balance > 0;
      final isLoading = state is ProfilesLoadingState;

      var countdownAmount = 0.0;
      if (state is ProfilesCountdownState) {
        countdownAmount = state.amount;
      }

      return WalletFrame(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Stack(
            children: [
              ListView(),
              Column(
                key: UniqueKey(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Heading2(text: state.activeProfile.firstName),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    GestureDetector(
                      onLongPress: () => context
                          .pushReplacementNamed(Pages.searchForCoin.name),
                      child: WalletWidget(
                        balance: state.activeProfile.wallet.balance,
                        countdownAmount: countdownAmount,
                      ),
                      onDoubleTap: () async {
                        final appId = await _getAppID();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "App ID: $appId",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  SizedBox(height: size.height * 0.01),
                  QrGiveButton(isActive: isGiveButtonActive),
                  if (isPending) SizedBox(height: size.height * 0.03),
                  if (isPending)
                    PendingApprovalWidget(
                      pending: state.activeProfile.wallet.pending,
                    ),
                ],
              ),
            ],
          ),
        ),
        fab: ProfileSwitchButton(
            name: state.activeProfile.firstName,
            onClicked: () {
              context.pushReplacementNamed(Pages.profileSelection.name);

              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.profileSwitchPressed,
              );
            }),
        fabLocation: FloatingActionButtonLocation.startFloat,
      );
    });
  }
}
