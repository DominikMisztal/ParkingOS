import 'package:meta/meta.dart';
import 'package:parking_system/models/car_model.dart';

@immutable
class UserDb {
  const UserDb ({
    required this.login,
    // required this.listOfCars,
  });

  final String login;
  // final List<Car> listOfCars;

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      // 'listOfCars': listOfCars,
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    return UserDb(
        login: map['login'] ?? '',
        // listOfCars: map['listOfCars'] ?? [],
        );
  }
}