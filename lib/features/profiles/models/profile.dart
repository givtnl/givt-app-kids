import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/history/models/donation.dart';
import 'package:givt_app_kids/features/profiles/models/wallet.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.hasDonations,
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
            type: '',
            hasDonations: false,
            wallet: const Wallet.empty(),
            lastDonationItem: Donation.empty(),
            pictureURL: '');

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final String type;
  final bool hasDonations;
  final Wallet wallet;
  final Donation lastDonationItem;
  final String pictureURL;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        nickname,
        comment,
        type,
        hasDonations,
        wallet,
        pictureURL
      ];
  Profile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? comment,
    String? type,
    bool? hasDonations,
    Wallet? wallet,
    Donation? lastDonationItem,
    String? pictureURL,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      hasDonations: hasDonations ?? this.hasDonations,
      wallet: wallet ?? this.wallet,
      lastDonationItem: lastDonationItem ?? this.lastDonationItem,
      pictureURL: pictureURL ?? this.pictureURL,
    );
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    final pictureMap = map['picture'];

    final donationMap = map['latestDonation'] == null
        ? Donation.empty()
        : Donation.fromMap(map['latestDonation']);

    final walletMap = map['wallet'] == null
        ? const Wallet.empty()
        : Wallet.fromMap(map['wallet']);

    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'] ?? '',
      nickname: map['nickname'] ?? '',
      comment: map['comment'] ?? '',
      type: map['type'] ?? '',
      hasDonations: map['hasDonations'] ?? false,
      wallet: walletMap,
      lastDonationItem: donationMap,
      pictureURL: pictureMap['pictureURL'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'comment': comment,
      'type': type,
      'hasDonations': hasDonations,
      'wallet': wallet.toJson(),
      'latestDonation': lastDonationItem.toJson(),
      'picture': {
        'pictureURL': pictureURL,
      }
    };
  }
}
