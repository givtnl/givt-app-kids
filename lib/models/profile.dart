import 'package:givt_app_kids/models/monsters.dart';

class Profile implements Comparable {
  final String guid;
  final String name;
  final double balance;
  final Monsters monster;
  final String createdAt;

  Profile({
    required this.guid,
    required this.name,
    required this.balance,
    required this.monster,
    required this.createdAt,
  });

  Profile.fromJson(Map<String, dynamic> json)
      : guid = json['guid'],
        name = json['name'],
        balance = json['balance'],
        monster = Monsters.values
            .firstWhere((element) => element.name == json['monster']),
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'name': name,
        'balance': balance,
        'monster': monster.name,
        'createdAt': createdAt,
      };

  @override
  int compareTo(other) {
    var createdAtThis = DateTime.parse(createdAt);
    var createdAtOther = DateTime.parse(other.createdAt);
    return createdAtOther.compareTo(createdAtThis);
  }
}
