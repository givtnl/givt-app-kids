import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/helpers/datetime_extension.dart';
import 'package:givt_app_kids/helpers/donation_state.dart';

class DonationItemWidget extends StatelessWidget {
  const DonationItemWidget({required this.donation, super.key});
  final HistoryItem donation;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: [
          SvgPicture.asset(getPicture(donation.state)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${donation.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: getAmountColor(donation.state),
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: donation.medium == DonationMediumType.nfc
                    ? size.width * 0.5
                    : size.width * 0.65,
                child: Text(
                  donation.organizationName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: Color(0xFF191C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                donation.state == DonationState.pending
                    ? 'Waiting for approval...'
                    : donation.date.formatDate(),
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          donation.medium == DonationMediumType.nfc
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Opacity(
                      opacity:
                          donation.state == DonationState.pending ? 0.6 : 1,
                      child: SvgPicture.asset('assets/images/coin.svg')),
                )
              : const SizedBox(),
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
