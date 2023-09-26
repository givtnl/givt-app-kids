import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/features/history/models/allowance.dart';
import 'package:givt_app_kids/helpers/datetime_extension.dart';

class AllowanceItemWidget extends StatelessWidget {
  const AllowanceItemWidget({required this.allowance, super.key});
  final Allowance allowance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset('assets/images/donation_states_added.svg'),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+ \$${allowance.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF06509B),
                  fontFamily: 'Roboto',
                ),
              ),
              const Text(
                'Awesome! Your parents added more allowance',
                style: TextStyle(
                  color: Color(0xFF191C1D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                allowance.date.formatDate(),
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
