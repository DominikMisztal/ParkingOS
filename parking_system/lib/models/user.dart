import 'package:meta/meta.dart';
import 'package:parking_system/models/car_model.dart';

@immutable
class UserDb {
  const UserDb ({
    required this.login,
    required this.balance,
    required this.listOfCars,
  });

  final String login;
  final double balance;
  final Map<String, Car> listOfCars;

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'balance': balance,
      'listOfCars': listOfCars.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? listOfCarsMap = map['listOfCars'] as Map<String, dynamic>?;

    return UserDb(
        login: map['login'] ?? '',
        balance: map['balance'] ?? 0,
        listOfCars: listOfCarsMap != null ? listOfCarsMap.map((key, value) => MapEntry(key, Car.fromMap(key, value))) : {},
        );
  }
  List<Car> userCars(){
    List<Car> cars  = listOfCars.values.toList();
    return cars;
  }

}