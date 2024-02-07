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

  Future<Map<String, List<double>>> getTarifs(String parkId) async {
    DataSnapshot snapshot = await _dbRef.child(parkId).get();
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    ParkingDb park = ParkingDb.fromMap(userData);
    return park.tarifs;
  }

  Future<List<String>?> getParkingNames() async {
  DataSnapshot snapshot = await _dbRef.get();
  if (snapshot.value == null) return null;
  Map<String, dynamic> parkingData = json.decode(json.encode(snapshot.value));
  List<String> parkingNames = parkingData.keys.toList();
  return parkingNames;
}

Future<List<ParkingDb>?> getParkings({String? parkingName, int? amountOfSpots, int? takenSpots, double? totalIncome, double? todayIncome, String? sortBy, bool? asc}) async {
  DataSnapshot snapshot = await _dbRef.get();
  if (snapshot.value == null) return null;

  Map<String, dynamic> parkingData = json.decode(json.encode(snapshot.value));
  List<ParkingDb> parkingList = [];

  parkingData.forEach((parkingName, parkingSpotData){
    ParkingDb parkingSpot = ParkingDb.fromMap(parkingSpotData);
    parkingList.add(parkingSpot);
  });

  for (var park in parkingList) {
    park.income = await setIncome(park.name);
    park.dailyIncome = await setTodayIncome(park.name);
  }

  if (parkingName != null) {
    parkingList = parkingList.where((park) => park.name.contains(parkingName)).toList();
  } else if (amountOfSpots != null) {
    parkingList = parkingList.where((park) => park.spots.length == amountOfSpots).toList();
  } else if (totalIncome != null) {
    parkingList = parkingList.where((park) => park.income == totalIncome).toList();
  } else if (todayIncome != null) {
    parkingList = parkingList.where((park) => park.dailyIncome == todayIncome).toList();
  }

  if (sortBy != null) {
    if(asc == true){
    parkingList.sort((a, b) {
      switch (sortBy) {
        case 'Parking Name':
          return a.name.compareTo(b.name);
        case 'Amount Of Spots':
          return a.spots.length.compareTo(b.spots.length);
        case 'Total Income':
          return a.income.compareTo(b.income);
        case 'Today\'s Income':
          return a.dailyIncome.compareTo(b.dailyIncome);
        default:
          return 0;
      }
    });
    }
    else{
      parkingList.sort((a, b) {
      switch (sortBy) {
        case 'Parking Name':
          return b.name.compareTo(a.name);
        case 'Amount Of Spots':
          return b.spots.length.compareTo(a.spots.length);
        case 'Total Income':
          return b.income.compareTo(a.income);
        case 'Today\'s Income':
          return b.dailyIncome.compareTo(a.dailyIncome);
        default:
          return 0;
      }
    });
    }
  }

  return parkingList;
}

  Future<double> setIncome(String parkingName) async {
      double totalIncome = 0;
      DatabaseReference _dbRef2 = FirebaseDatabase.instance.ref().child('parking_history').child(parkingName);
      DataSnapshot parkingSnapshot = await _dbRef2.get();

      if (parkingSnapshot.value != null && parkingSnapshot.value is Map<String, dynamic>) {
        Map<String, dynamic> parkingData = parkingSnapshot.value as Map<String, dynamic>;
        
        parkingData.forEach((spotKey, spotData) {
          if (spotData is Map<String, dynamic>) {
            spotData.forEach((date, takeIncome) {
                totalIncome += takeIncome['income'] ;
            });
          }
        });
      }
      return totalIncome;
  }

    Future<double> setTodayIncome(String parkingName) async {
      double totalIncome = 0;
      DatabaseReference _dbRef2 = FirebaseDatabase.instance.ref().child('parking_history').child(parkingName);
      DataSnapshot parkingSnapshot = await _dbRef2.get();

      if (parkingSnapshot.value != null && parkingSnapshot.value is Map<String, dynamic>) {
        Map<String, dynamic> parkingData = parkingSnapshot.value as Map<String, dynamic>;
        
        parkingData.forEach((spotKey, spotData) {
          if (spotData is Map<String, dynamic>) {
            spotData.forEach((date, takeIncome) {
              DateTime checkDate = DateTime.parse(date);
              DateTime now = DateTime.now();
              if(checkDate.day == now.day && checkDate.year == now.year && checkDate.month == now.month)
                totalIncome += takeIncome['income'] ;
            });
          }
        });
      }
      return totalIncome;
  }

  Future<SpotDb?> getSpotFromParking(String parkingName, int spotName) async {
    DataSnapshot snapshot = await _dbRef.child(parkingName).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return SpotDb.fromMap(userData);
  }

  Future<void> startParking(int spotId, String parkingName, String? registration, int lvl, Layover ticket, String ticketKey) async {
    if(registration == null) return;
    SpotDb spot = SpotDb(registrationNumber: registration, date: DateTime.now().toString(), level: lvl, idNumber: spotId);

    Map<String, dynamic> spotMap = {
      'registrationNumber': spot.registrationNumber,
      'date': spot.date,
      'level': spot.level,
      'idNumber': spot.idNumber,
    };

    await _dbRef.child(parkingName).child('spots').child(spotId.toString()).set(spotMap);
    ticketService.addTicket(ticket, ticketKey);
  }

  Future<void> moveFromParking(int spotId, String parkingName, double cost, String userLogin) async {

    DataSnapshot dataSnapshot = await _dbRef.child(parkingName).child('spots').child(spotId.toString()).get();
    Map<String, dynamic>? spotData = dataSnapshot.value as Map<String, dynamic>?;
    if(spotData != null){
      String date = spotData['date'] ?? '';
      String registrationNumber = spotData['registrationNumber'] ?? '';

      spotData['registrationNumber'] = '';
      spotData['date'] = '';
      
      print(date);
      if(date == ''){
        date = DateTime.now().toString();
      }

      parkHistory.addToParkingHistory(parkingName, spotId.toString(), registrationNumber, DateTime.parse(date), DateTime.now(), cost);
      //print(parkingName);
      //print(spotData);
      await _dbRef.child(parkingName).child('spots').child(spotId.toString()).update(spotData);
      
      ticketService.updateTicketEndDate(userLogin);
    }
  }
}
