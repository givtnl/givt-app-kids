enum DonationState {
  pending,
  approved,
  declined;

  static DonationState getState(String? state) {
    switch (state) {
      case 'ParentApprovalPending':
        return DonationState.pending;
      case 'Entered':
        return DonationState.approved;
      case 'ToProcess':
        return DonationState.approved;
      case 'Processed':
        return DonationState.approved;
      case 'Rejected':
        return DonationState.declined;
      case 'Cancelled':
        return DonationState.declined;
      default:
        return DonationState.pending;
    }
  }

  static String getDonationStateString(DonationState state) {
    switch (state) {
      case DonationState.pending:
        return 'ParentApprovalPending';
      case DonationState.approved:
        return 'Processed';
      case DonationState.declined:
        return 'Cancelled';
    }
  }
}

enum DonationMediumType {
  qr(type: 'QR'),
  nfc(type: 'NFC'),
  unknown(type: '');

  final String type;
  const DonationMediumType({required this.type});
}
