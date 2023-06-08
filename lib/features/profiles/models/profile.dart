import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.firstName,
    required this.lastName,
    required this.balance,
  });

  const Profile.empty()
      : this(firstName: 'Empty First', lastName: 'Empty Last', balance: 9.99);

  final String firstName;
  final String lastName;
  final double balance;

  @override
  List<Object?> get props => [firstName, lastName, balance];
}
