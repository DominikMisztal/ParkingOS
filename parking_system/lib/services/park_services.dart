import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/Spot.dart';

class ParkingServices {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('parkings');

  Future<void> addParking(ParkingDb parkingDb) async {
    Map<String, dynamic> parkingMap = parkingDb.toMap();
    await _dbRef.child(parkingDb.name).set(parkingMap);
  }

  Future<ParkingDb?> getParkingFromName(String name) async {
    DataSnapshot snapshot = await _dbRef.child(name).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return ParkingDb.fromMap(userData);
  }

  Future<SpotDb?> getSpotFromParking(String parkingName, int spotName) async {
    DataSnapshot snapshot = await _dbRef.child(parkingName).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return SpotDb.fromMap(userData);
  }

  //Future<CarHistoryDb?> getHistoryOfCar(String registration) async{
    
  //}

  // Future<SpotDb?> getRoomByNumber(int roomNum) async {
  //   Query query = _roomRef.orderByChild('number').equalTo(roomNum);
  //   DataSnapshot snapshot = await query.get();
  //   if (snapshot.value == null) return null;
  //   Map<String, dynamic> roomData = json.decode(json.encode(snapshot.value));
  //   String roomId = roomData.keys.first;
  //   return SpotDb.fromMap(roomData[roomId]);
  // }

}
