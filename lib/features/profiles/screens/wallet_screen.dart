import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _WalletScreenCubitState extends State<WalletScreenCubit> {
  double pendingDifference = 0.0;
  @override
  void initState() {
    pendingDifference = context.read<ProfilesCubit>().getPendingDifference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      final isPending = state.activeProfile.wallet.pending > 0.0;
      final isGiveButtonActive = state.activeProfile.wallet.balance > 0;
      final passedDifference =
          ModalRoute.of(context)!.settings.arguments as double?;
      log('passedDifference: $passedDifference');
      var countdownAmount = 0.0;
      if (state is ProfilesCountdownState) {
        countdownAmount = state.amount;
      }

      if (pendingDifference > 0) {
        // their donation was approved or declined
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '\$$pendingDifference has been approved or declined from ${state.activeProfile.firstName}\'s wallet',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      return WalletFrame(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Heading2(text: state.activeProfile.firstName),
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
                difference: passedDifference ?? pendingDifference,
              ),
          ],
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
