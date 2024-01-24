import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    super.key,
    required this.balance,
    required this.hasDonations,
    this.countdownAmount = 0,
  });
  final double balance;
  final bool hasDonations;
  final double countdownAmount;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Stack(children: [
        Positioned(
          bottom: 0,
          width: MediaQuery.sizeOf(context).width,
          child: SvgPicture.asset(
            'assets/images/wallet_background.svg',
            fit: BoxFit.cover,
          ),
        ),
        BlocBuilder<ProfilesCubit, ProfilesState>(
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/images/wallet_coins.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                state is ProfilesLoadingState
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Countup(
                        begin: balance + countdownAmount,
                        end: balance,
                        duration: const Duration(seconds: 3),
                        separator: '.',
                        prefix: '\$ ',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                SizedBox(height: hasDonations ? 0 : 8),
                hasDonations
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(Pages.history.name);
                            AnalyticsHelper.logEvent(
                              eventName:
                                  AmplitudeEvent.seeDonationHistoryPressed,
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'All givts',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  FontAwesomeIcons.arrowRight,
                                  size: 24,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              )
                            ],
                          ),
                        ))
                    : const SizedBox(),
              ],
            );
          },
        ),
      ]),
    );
  }
}
