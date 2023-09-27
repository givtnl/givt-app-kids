import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/find_charity_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/donation_item.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/shared/widgets/qr_give_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_frame.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
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
                    ),
                  SizedBox(height: size.height * 0.01),
                  QrGiveButton(isActive: isGiveButtonActive),
                  const FindCharityButton(),
                  SizedBox(height: size.height * 0.02),
                  state.activeProfile.donationItem.amount == 0
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('My givts',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextButton(
                                onPressed: () =>
                                    context.pushNamed(Pages.history.name),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 0)),
                                ),
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    color: Color(0xFF3B3240),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ))
                          ],
                        ),
                  state.activeProfile.donationItem.amount == 0
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () => context.pushNamed(Pages.history.name),
                          child: DonationItemWidget(
                            donation: state.activeProfile.donationItem,
                          ),
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
