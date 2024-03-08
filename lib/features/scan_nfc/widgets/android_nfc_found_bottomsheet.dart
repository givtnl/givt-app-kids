import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';

class FoundNfcAnimation extends StatelessWidget {
  const FoundNfcAnimation(
      {required this.scanNfcCubit,
      required this.isLoading,
      required this.onPressed,
      super.key});
  final ScanNfcCubit scanNfcCubit;
  final bool isLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Found it!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          Container(
            height: 160,
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: SvgPicture.asset('assets/images/coin_found.svg'),
          ),
          const Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: GivtElevatedButton(
              isDisabled: true,
              onTap: null,
              text: '',
            ),
          ),
        ],
      ),
    );
  }
}
