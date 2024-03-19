import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:go_router/go_router.dart';

class NfcNotAvailableSheet extends StatelessWidget {
  const NfcNotAvailableSheet({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Text(
          'Oh wait, we can\'t scan the coin',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Container(
          // hardcoded size from design file
          height: 160,
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: SvgPicture.asset(
            "assets/images/not_found_phone.svg",
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
          ),
        ),
        Text(
          'Could you turn on NFC so we are\nable to find it?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GivtElevatedButton(
            onTap: () {
              context.pop();
              scanNfcCubit.cancelScanning();
              AppSettings.openAppSettings(type: AppSettingsType.nfc);
            },
            text: 'Go to Settings',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: GivtElevatedSecondaryButton(
            onTap: () {
              context.pop();
              scanNfcCubit.cancelScanning();
            },
            text: 'Cancel',
          ),
        )
      ],
    );
  }
}
