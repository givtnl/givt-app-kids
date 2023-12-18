import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/widgets/action_tile.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class GiveBottomSheet extends StatelessWidget {
  const GiveBottomSheet({required this.isiPad, super.key});
  final bool isiPad;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isiPad
                  ? const SizedBox()
                  : ActionTile(
                      isDisabled: false,
                      text: "Coin",
                      iconPath: 'assets/images/give_with_coin.svg',
                      backgroundColor: AppTheme.highlight98,
                      borderColor: AppTheme.highlight80,
                      textColor: AppTheme.highlight40,
                      onTap: () {
                        context.pop();
                        context.pushNamed(Pages.scanNFC.name);
                        context.read<FlowsCubit>().startInAppCoinFlow();
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvent.choseGiveWithCoin,
                        );
                      }),
              isiPad ? const SizedBox() : const SizedBox(width: 16),
              ActionTile(
                isDisabled: false,
                text: "QR Code",
                iconPath: 'assets/images/give_with_qr.svg',
                borderColor: Theme.of(context).colorScheme.onInverseSurface,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                textColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvent.choseGiveWithQRCode,
                  );
                  context.pushNamed(Pages.camera.name);
                  context.read<FlowsCubit>().startInAppQRCodeFlow();
                },
              ),
            ],
          ),
          SizedBox(height: size.width * 0.05),
          ElevatedButton(
            onPressed: () {
              context.pop();
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvent.cancelGive,
              );
            },
            style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(double.maxFinite, 60),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.xmark,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
