import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';

class SchoolEventCoinWidget extends StatelessWidget {
  const SchoolEventCoinWidget({
    required this.amount,
    super.key,
  });

  final double amount;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 220,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset('assets/images/school_event_coin_rays.svg'),
          ),
          Positioned(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/school_event_coin.svg',
                width: 120,
                height: 120,
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: Text(
                '\$${amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.highlight40,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
