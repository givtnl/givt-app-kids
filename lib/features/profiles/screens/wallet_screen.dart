import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/profiles/widgets/pending_approval_widget.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';
import 'package:givt_app_kids/shared/widgets/qr_give_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_frame.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';

class WalletScreenCubit extends StatefulWidget {
  static const String routeName = "/wallet-cubit";

  const WalletScreenCubit({super.key});

  @override
  State<WalletScreenCubit> createState() => _WalletScreenCubitState();
}

class _WalletScreenCubitState extends State<WalletScreenCubit>
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
    refresh();
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
                    WalletWidget(
                      balance: state.activeProfile.wallet.balance,
                      countdownAmount: countdownAmount,
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
              Navigator.of(context)
                  .pushReplacementNamed(ProfileSelectionScreen.routeName);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.profileSwitchPressed,
              );
            }),
        fabLocation: FloatingActionButtonLocation.startFloat,
      );
    });
  }
}
