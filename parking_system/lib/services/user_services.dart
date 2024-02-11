import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/services/user_auth.dart';

class UserService {
  UserAuth userAuth = UserAuth();
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('Users');

  Future<void> addUser(String uID, UserDb user) async {
    Map<String, dynamic> userMap = user.toMap();
    await _userRef.child(uID).set(userMap);
  }

  Future<bool?> canAddCar(String registrationPlate) async {
    DatabaseReference usersRef = _userRef;

    DataSnapshot usersEvent = await usersRef.get();

    if (usersEvent.value != null) {
      if (usersEvent.value is Map<String, dynamic>) {
        Map<String, dynamic> users = usersEvent.value as Map<String, dynamic>;
        for (String userId in users.keys) {
          DatabaseReference userCarsRef =
              usersRef.child(userId).child('listOfCars');
          DataSnapshot userCarsEvent = await userCarsRef.get();
          if (userCarsEvent.value != null &&
              userCarsEvent.value is Map<String, dynamic>) {
            Map<String, dynamic> userCars =
                userCarsEvent.value as Map<String, dynamic>;
            if (userCars.containsKey(registrationPlate)) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  Future<UserDb?> getUserByUID(String uID) async {
    DataSnapshot snapshot = await _userRef.child(uID).get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    print(userData);
    return UserDb.fromMap(userData);
  }

  Future<void> blockUser(String login, bool block) async {
    DataSnapshot snapshot = await _userRef.get();

    if (snapshot.value != null) {
      Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));

      userData.forEach((key, value) async {
        if (value['login'] == login) {
          await _userRef.child(key).update({'isBlocked': block});
        }
      });
    }
  }

  Future<List<UserDb>> getAllUsers() async {
    DataSnapshot snapshot = await _userRef.get();
    List<UserDb> userList = [];

    if (snapshot.value == null) return userList;

    Map<String, dynamic> userData =
        Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

    userData.forEach((key, value) {
      userList.add(UserDb.fromMap(value));
    });

    return userList;
  }

  Future<Car?> getCarByRegistration(String registrationNum) async {
    DataSnapshot usersSnapshot = await _userRef.get();
    Map<dynamic, dynamic>? usersData =
        usersSnapshot.value as Map<String, dynamic>?;

    if (usersData != null) {
      for (var userDataKey in usersData.keys) {
        Map<dynamic, dynamic>? userData = usersData[userDataKey];
        if (userData != null && userData['listOfCars'] != null) {
          Map<dynamic, dynamic> listOfCars = userData['listOfCars'];
          if (listOfCars.containsKey(registrationNum)) {
            return Car.fromMap(registrationNum, listOfCars[registrationNum]);
          }
        }
      }
    }
    return null;
  }

  Future<List<Car?>> getAllCars(
      {String? registration,
      String? brand,
      String? model,
      String? sortBy,
      bool? asc}) async {
    DataSnapshot usersSnapshot = await _userRef.get();
    Map<dynamic, dynamic>? usersData =
        usersSnapshot.value as Map<String, dynamic>?;
    List<Car?> allCars = [];
    if (usersData != null) {
      for (var userDataKey in usersData.keys) {
        Map<dynamic, dynamic>? userData = usersData[userDataKey];
        if (userData != null && userData['listOfCars'] != null) {
          Map<dynamic, dynamic> listOfCars = userData['listOfCars'];
          listOfCars.forEach((registrationNum, carData) {
            Car? car = Car.fromMap(registrationNum, carData);
            bool matchesFilter = true;
            if (registration != null && car.registration_num != registration) {
              matchesFilter = false;
            }
            if (brand != null && car.brand != brand) {
              matchesFilter = false;
            }
            if (model != null && car.model != model) {
              matchesFilter = false;
            }

            if (matchesFilter) {
              allCars.add(car);
            }
          });
        }
      }
    }

    if (sortBy != null) {
      allCars.sort((a, b) {
        int result = 0;
        switch (sortBy) {
          case 'Vehicle Registration':
            result = a!.registration_num.compareTo(b!.registration_num);
            break;
          case 'Vehicle Brand':
            result = a!.brand.compareTo(b!.brand);
            break;
          case 'Model':
            result = a!.model.compareTo(b!.model);
            break;
          default:
            break;
        }
        return asc != null && asc == true ? result : -result;
      });
    }
    return allCars;
  }

  Future<String?> getLoginForCurrentUser() async {
    String? uid = await userAuth.getCurrentUserUid();
    if (uid != null) {
      DataSnapshot snapshot = await _userRef.child(uid).child('login').get();

      if (snapshot.value != null) {
        String login;

        String carsMap = snapshot.value as String;
        login = carsMap;
        return login;
      }
      ;
    } else {
      return "";
    }
  }

  Future<List<Car>> getCars() async {
    String? uid = await userAuth.getCurrentUserUid();
    if (uid != null) {
      DataSnapshot snapshot =
          await _userRef.child(uid).child('listOfCars').get();

      if (snapshot.value != null) {
        List<Car> cars = [];

        Map<dynamic, dynamic> carsMap = snapshot.value as Map<dynamic, dynamic>;
        carsMap.forEach((registrationNum, carData) {
          Car car = Car.fromMap(registrationNum, carData);
          cars.add(car);
        });

        return cars;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<double> getBalance() async {
    String? uid = await userAuth.getCurrentUserUid();
    if (uid != null) {
      DataSnapshot snapshot = await _userRef.child(uid).child('balance').get();
      if (snapshot.value != null) {
        return (snapshot.value as num).toDouble();
        ;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  void addBalance(double totalAmount) async {
    String? uid = await userAuth.getCurrentUserUid();
    if (uid != null) {
      await _userRef.child(uid).update({
        'balance': totalAmount,
      });
    }
  }

  Future<void> updateCars(Map<String, Car> cars) async {
    String? uid = await userAuth.getCurrentUserUid();
    if (uid != null) {
      Map<String, dynamic> carsMap = {};
      cars.forEach((registrationNum, car) {
        carsMap[registrationNum] = {
          'brand': car.brand,
          'model': car.model,
        };
      });

      Map<String, dynamic> updateData = {'listOfCars': carsMap};
      await _userRef.child(uid).update(updateData);
    }
  }
}
