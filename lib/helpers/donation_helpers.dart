enum DonationState {
  pending,
  approved,
  declined;
}

enum DonationMedium {
  qr(medium: 'QR'),
  nfc(medium: 'NFC'),
  unknown(medium: '');

  final String medium;
  const DonationMedium({required this.medium});
}

DonationState getState(String? state) {
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
