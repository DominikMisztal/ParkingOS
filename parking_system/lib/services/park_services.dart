import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/Spot.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/ticket_services.dart';

class ParkingServices {
  ParkHistory parkHistory = ParkHistory();
  TicketService ticketService = TicketService();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('parkings');

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

  Future<List<String>?> getParkingNames() async {
  DataSnapshot snapshot = await _dbRef.get();
  if (snapshot.value == null) return null;
  Map<String, dynamic> parkingData = json.decode(json.encode(snapshot.value));
  List<String> parkingNames = parkingData.keys.toList();
  return parkingNames;
}

Future<List<ParkingDb>?> getParkings() async {
  DataSnapshot snapshot = await _dbRef.get();
  if (snapshot.value == null) return null;

  Map<String, dynamic> parkingData = json.decode(json.encode(snapshot.value));
  List<ParkingDb> parkingList = [];

  parkingData.forEach((parkingName, parkingSpotData) {
    ParkingDb parkingSpot = ParkingDb.fromMap(parkingSpotData);
    parkingList.add(parkingSpot);
  });

  return parkingList;
}

  Future<SpotDb?> getSpotFromParking(String parkingName, int spotName) async {
    DataSnapshot snapshot = await _dbRef.child(parkingName).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return SpotDb.fromMap(userData);
  }

  Future<void> startParking(int spotId, String parkingName, String? registration, int lvl, Layover ticket, String ticketKey) async {
    if(registration == null) return;
    SpotDb spot = SpotDb(registrationNumber: registration, date: "", level: lvl, idNumber: spotId);

    Map<String, dynamic> spotMap = {
      'registrationNumber': spot.registrationNumber,
      'date': spot.date,
      'level': spot.level,
      'idNumber': spot.idNumber,
    };

    await _dbRef.child(parkingName).child('spots').child(spotId.toString()).set(spotMap);
    ticketService.addTicket(ticket, ticketKey);
  }

  Future<void> moveFromParking(int spotId, String parkingName, int level, double cost) async {
    Map<String, dynamic> spotMap = {
      'registrationNumber': "",
      'date': "",
      'level': level,
      'idNumber': spotId,
    };

    DataSnapshot dataSnapshot = await _dbRef.child(parkingName).child('spots').child(spotId.toString()).get();
    Map<String, dynamic>? spotData = dataSnapshot.value as Map<String, dynamic>?;
    if(spotData != null){
      String date = spotData['date'] ?? '';
      String registrationNumber = spotData['registrationNumber'] ?? '';
      
      parkHistory.addToParkingHistory(parkingName, spotId.toString(), registrationNumber, DateTime.parse(date), DateTime.now(), cost);
      await _dbRef.child(parkingName).child('spots').child(spotId.toString()).set(spotMap);
      ticketService.payForTicket();
    }
  }
}
