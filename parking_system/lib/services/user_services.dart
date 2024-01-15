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

 

  Future<UserDb?> getUserByUID(String uID) async {
    DataSnapshot snapshot = await _userRef.child(uID).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    print(userData);
    return UserDb.fromMap(userData);
  }

  void addBalance(double totalAmount) async {
    String? uid = await userAuth.getCurrentUserUid();
    if(uid != null){
      await _userRef.child(uid).update({
      'balance': totalAmount,
    });
    }
  }

}
