import 'package:meta/meta.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/services/user_services.dart';

@immutable
class UserDb {
  UserDb(
      {required this.login,
      required this.balance,
      required this.listOfCars,
      this.blocked = false});

  final String login;
  double balance;
  final Map<String, Car> listOfCars;
  bool blocked;

  void addBalance(double value) {
    balance += value;
  }

  Future<Map<String, Car>> addCar(Car car) async {
    UserService userService = UserService();
    MapEntry<String, Car> entry = MapEntry(car.registration_num, car);
    listOfCars.addEntries([entry]);
    await userService.updateCars(listOfCars);

    return listOfCars;
  }

  Future<Map<String, Car>> deleteCar(String plate) async {
    UserService userService = UserService();

    listOfCars.removeWhere((key, value) => value.registration_num == plate);

    await userService.updateCars(listOfCars);

    return listOfCars;
  }

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'balance': balance,
      'isBlocked': blocked,
      'listOfCars':
          listOfCars.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory UserDb.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? listOfCarsMap =
        map['listOfCars'] as Map<String, dynamic>?;

    return UserDb(
      login: map['login'] ?? '',
      blocked: map['isBlocked'] ?? false,
      balance: map['balance'] ?? 0,
      listOfCars: listOfCarsMap != null
          ? listOfCarsMap
              .map((key, value) => MapEntry(key, Car.fromMap(key, value)))
          : {},
    );
  }
  List<Car> userCars() {
    List<Car> cars = listOfCars.values.toList();
    return cars;
  }
}
