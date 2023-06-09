import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.balance,
    required this.pictureURL,
  });

  const Profile.empty()
      : this(
            id: '',
            firstName: '',
            lastName: '',
            nickname: '',
            comment: '',
            balance: 0.0,
            pictureURL: '');

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final double balance;
  final String pictureURL;

  @override
  List<Object?> get props =>
      [id, firstName, lastName, nickname, comment, balance, pictureURL];

  factory Profile.fromMap(Map<String, dynamic> map) {
    final pictureMap = map['picture'];
    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      nickname: map['nickname'] ?? '',
      comment: map['comment'] ?? '',
      balance: map['balance'],
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
      'balance': balance,
      'picture': {
        'pictureURL': pictureURL,
      }
    };
  }
}
