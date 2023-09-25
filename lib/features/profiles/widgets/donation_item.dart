import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/profiles/models/donation.dart';
import 'package:givt_app_kids/helpers/util.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.donation, super.key});
  final Donation donation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SvgPicture.asset(getPicture(donation.state)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${donation.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: getAmountColor(donation.state),
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                donation.organizationName,
                style: const TextStyle(
                  color: Color(0xFF191C1D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                donation.state == DonationState.pending
                    ? 'Waiting for approval...'
                    : Util.formatDate(donation.date),
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Opacity(
                opacity: donation.state == DonationState.pending ? 0.6 : 1,
                child: SvgPicture.asset('assets/images/coin.svg')),
          ),
        ],
      ),
    );
  }

  String getPicture(DonationState status) {
    switch (status) {
      case DonationState.approved:
        return 'assets/images/donation_states_approved.svg';
      case DonationState.pending:
        return 'assets/images/donation_states_pending.svg';
      case DonationState.declined:
        return 'assets/images/donation_states_declined.svg';
    }
  }

  Color getAmountColor(DonationState status) {
    switch (status) {
      case DonationState.approved:
        return const Color(0xFF006C47);
      case DonationState.pending:
        return const Color(0xFF48260C);
      case DonationState.declined:
        return const Color(0xFF780F0F);
    }
  }
}
