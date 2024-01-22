import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/services/user_auth.dart';

class UserService {
  UserAuth userAuth = UserAuth();
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('Users');


  Future<void> addUser(String uID, UserDb user) async {
    Map<String, dynamic> userMap = user.toMap();
    await _userRef.child(uID).set(userMap);
  }

Future<bool?> canAddCar(String registrationPlate) async {
  DatabaseReference usersRef = _userRef;

  DatabaseEvent usersEvent = await usersRef.once();

  if (usersEvent.snapshot.value != null) {
    if (usersEvent.snapshot.value is Map<String, dynamic>) {
      Map<String, dynamic> users = usersEvent.snapshot.value as Map<String, dynamic>;
      for (String userId in users.keys) {
        DatabaseReference userCarsRef = usersRef.child(userId).child('listOfCars');
        DatabaseEvent userCarsEvent = await userCarsRef.once();
        if (userCarsEvent.snapshot.value is Map<String, dynamic>) {
          Map<String, dynamic> userCars = userCarsEvent.snapshot.value as Map<String, dynamic>;
          if (userCars.containsValue(registrationPlate)) {
            print(registrationPlate);
            return false;
          }
        }
      }
    }
  }
  print('returned true');
  return true;
}

 

  Future<UserDb?> getUserByUID(String uID) async {
    DataSnapshot snapshot = await _userRef.child(uID).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    print(userData);
    return UserDb.fromMap(userData);
  }

  Future<Car?> getCarByRegistration(String registrationNum) async {
    DataSnapshot usersSnapshot = await _userRef.get();
    Map<dynamic, dynamic>? usersData = usersSnapshot.value as Map<String, dynamic>?;

    if (usersData != null) {
      for (var userDataKey in usersData.keys) {
        Map<dynamic, dynamic>? userData = usersData[userDataKey];
        if (userData != null && userData['listOfCars'] != null) {
          Map<dynamic, dynamic> listOfCars = userData['listOfCars'];
          if (listOfCars.containsKey(registrationNum)) {
            return Car.fromMap(registrationNum,listOfCars[registrationNum]);
          }
        }
      }
    }

    return null; // Car with the specified registration not found
}

  void addBalance(double totalAmount) async {
    String? uid = await userAuth.getCurrentUserUid();
    if(uid != null){
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
