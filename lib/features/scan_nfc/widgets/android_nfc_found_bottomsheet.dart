import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';

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
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Found it!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset('assets/images/mobile_found.svg'),
          ),
          const Text('Now let\'s select the amount',
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          const Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: FloatingActoinButton(
              text: "",
            ),
          ),
        ],
      ),
    );
  }
}
