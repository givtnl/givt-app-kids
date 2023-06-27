import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({super.key, required this.balance});
  final double balance;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 25, bottom: 10, right: 0),
          margin: const EdgeInsets.only(bottom: 15, top: 15),
          decoration: const BoxDecoration(
            color: Color(0xFF54A1EE),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: "\$",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: balance.toString(),
                          ),
                        ],
                      ),
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
