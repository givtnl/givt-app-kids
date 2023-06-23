import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app_kids/features/profiles/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/widgets/qr_give_button.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_frame.dart';
import 'package:givt_app_kids/features/profiles/widgets/wallet_widget.dart';
import 'package:givt_app_kids/widgets/heading_3.dart';

class WalletScreenCubit extends StatefulWidget {
  static const String routeName = "/wallet-cubit";

  const WalletScreenCubit({super.key});

  @override
  State<WalletScreenCubit> createState() => _WalletScreenCubitState();
}

class _WalletScreenCubitState extends State<WalletScreenCubit> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfilesCubit, ProfilesState>(builder: (context, state) {
      return WalletFrame(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header3(name: state.activeProfile.firstName),
            WalletWidget(balance: state.activeProfile.balance),
            SizedBox(height: size.height * 0.01),
            const QrGiveButton(),
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
