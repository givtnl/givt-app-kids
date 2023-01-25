import 'package:givt_app_kids/models/monsters.dart';

class Profile {
  final String guid;
  final String name;
  final double balance;
  final Monsters monster;

  Profile({
    required this.guid,
    required this.name,
    required this.balance,
    required this.monster,
  });

  Profile.fromJson(Map<String, dynamic> json)
      : guid = json['guid'],
        name = json['name'],
        balance = json['balance'],
        monster = Monsters.values
            .firstWhere((element) => element.name == json['monster']);

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'name': name,
        'balance': balance,
        'monster': monster.name,
      };
}
