import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/Spot.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/ticket_services.dart';

class ExpensesServices {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('services');

  // Future<void> loadServicesForPark(ParkingDb parkingDb) async {
  //   Map<String, dynamic> parkingMap = parkingDb.toMap();
  //   await _dbRef.child(parkingDb.name).set(parkingMap);
  // }

  Future<ParkingDb?> saveExpensesForParking(String name, List<String> services) async {
    DataSnapshot snapshot = await _dbRef.child(name).get();
    if(snapshot.value == null) return null;
    await _dbRef.child(name).set(services);
  }

}