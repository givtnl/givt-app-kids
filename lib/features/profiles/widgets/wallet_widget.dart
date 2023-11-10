import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    super.key,
    required this.balance,
    this.countdownAmount = 0,
  });
  final double balance;
  final double countdownAmount;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 25, bottom: 25, right: 0),
          margin: const EdgeInsets.only(bottom: 15, top: 15),
          decoration: const BoxDecoration(
            color: AppTheme.walletBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Row(
            children: [
              const Spacer(flex: 4),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Text(
                      "Balance available",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.darkBlueTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "\$ ",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.darkBlueTextColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Countup(
                          begin: balance + countdownAmount,
                          end: balance,
                          duration: const Duration(seconds: 3),
                          separator: '.',
                          style: const TextStyle(
                            fontSize: 32,
                            color: AppTheme.darkBlueTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          child: SvgPicture.asset(
              height: 140, fit: BoxFit.fitHeight, "assets/images/wallet.svg"),
        ),
      ],
    );
  }
}
