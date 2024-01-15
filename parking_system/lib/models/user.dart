import 'package:meta/meta.dart';
import 'package:parking_system/models/car_model.dart';

@immutable
class UserDb {
  const UserDb ({
    required this.login,
    required this.balance,
    // required this.listOfCars,
  });

  final String login;
  final int balance;
  // final List<Car> listOfCars;

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'balance': balance,
      // 'listOfCars': listOfCars,
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    return UserDb(
        login: map['login'] ?? '',
        balance: map['balance'] ?? 0,
        // listOfCars: map['listOfCars'] ?? [],
        );
  }
}