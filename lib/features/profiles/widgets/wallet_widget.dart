import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({
    super.key,
    required this.balance,
    required this.hasDonations,
    this.avatarUrl = '',
    this.countdownAmount = 0,
  });
  final double balance;
  final bool hasDonations;
  final double countdownAmount;
  final String avatarUrl;

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  Future<String> _getAppIDAndVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final result =
        '${packageInfo.packageName} v${packageInfo.version}(${packageInfo.buildNumber})';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Stack(
          children: [
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
                    const SizedBox(height: 10),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () {
                            SystemSound.play(SystemSoundType.click);
                            context.pushNamed(Pages.avatarSelection.name);
                          },
                          customBorder: const CircleBorder(),
                          splashColor: Theme.of(context).primaryColor,
                          onDoubleTap: () async {
                            final appInfoString = await _getAppIDAndVersion();
                            if (mounted) {
                              SnackBarHelper.showMessage(context,
                                  text: appInfoString);
                            }
                          },
                          child: SvgPicture.network(
                            widget.avatarUrl,
                            width: 120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    state is ProfilesLoadingState
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Countup(
                            begin: widget.balance + widget.countdownAmount,
                            end: widget.balance,
                            duration: const Duration(seconds: 3),
                            separator: '.',
                            prefix: '\$ ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                    widget.hasDonations
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
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: widget.hasDonations ? 0 : 8),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
