import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/wallet/cubit/widgets/name_bold.dart';
import 'package:givt_app_kids/features/wallet/cubit/widgets/profile_switch_button.dart';
import 'package:givt_app_kids/features/wallet/cubit/widgets/wallet_frame.dart';
import 'package:givt_app_kids/features/wallet/cubit/widgets/wallet_widget.dart';

import 'cubit/wallet_cubit.dart';

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
            NameBold(name: state.activeProfile.firstName),
            WalletWidget(balance: state.activeProfile.balance),
          ],
        ),
        fab: ProfileSwitchButton(
            name: state.activeProfile.firstName, onClicked: () {}),
        fabLocation: FloatingActionButtonLocation.endTop,
      );
    });
  }
}
