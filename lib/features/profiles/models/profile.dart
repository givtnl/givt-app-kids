import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/features/profiles/models/wallet.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.lastDonationItem,
    required this.pictureURL,
  });

  Profile.empty()
      : this(
            id: '',
            firstName: '',
            lastName: '',
            nickname: '',
            comment: '',
            wallet: const Wallet.empty(),
            lastDonationItem: HistoryItem.empty(),
            pictureURL: '');

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final Wallet wallet;
  final HistoryItem lastDonationItem;
  final String pictureURL;

  @override
  List<Object?> get props =>
      [id, firstName, lastName, nickname, comment, wallet, pictureURL];

  factory Profile.fromMap(Map<String, dynamic> map) {
    final pictureMap = map['picture'];

    final donationMap = map['latestDonation'] == null
        ? HistoryItem.empty()
        : HistoryItem.fromMap(map['latestDonation']);

    final walletMap = map['wallet'] == null
        ? const Wallet.empty()
        : Wallet.fromMap(map['wallet']);

    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'] ?? '',
      nickname: map['nickname'] ?? '',
      comment: map['comment'] ?? '',
      wallet: walletMap,
      lastDonationItem: donationMap,
      pictureURL: pictureMap['pictureURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'comment': comment,
      'wallet': wallet.toJson(),
      'latestDonation': lastDonationItem.toJson(),
      'picture': {
        'pictureURL': pictureURL,
      }
    };
  }
}
