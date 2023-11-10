import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinWidget extends StatelessWidget {
  const CoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SvgPicture.asset(
        'assets/images/coin_activated_small.svg',
      ),
    );
  }
}
