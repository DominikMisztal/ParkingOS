import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/Spot.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/models/statistics/parkingHistoryRecord.dart';

class ParkHistory {
  UserService userService = UserService();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('parking_history');

  Future<void> addToParkingHistory(String parkingName, String spotId, String registration, DateTime parkingStarted, DateTime parkingEnded, double income) async {

    int dotIndex = parkingStarted.toString().indexOf('.');
    String newParkingStarted = parkingStarted.toString();
    String newParkingEnded = parkingEnded.toString();
    if (dotIndex != -1) {
      newParkingStarted = parkingStarted.toString().substring(0, dotIndex);
      newParkingEnded = parkingEnded.toString().substring(0, dotIndex);
    }

    Map<String, dynamic> newRecord = {
      'registration': registration,
      'spot': spotId,
      'parkingStarted': newParkingStarted.toString(),
      'parkingEnded': newParkingEnded.toString(),
      'income': income,
    };

    print(newRecord);

    await _dbRef
        .child(parkingName)
        .child(spotId)
        .child(newParkingStarted)
        .set(newRecord);
  }

Future<List<String>?> getAllRegistrations() async {

    DataSnapshot dataSnapshot = await _dbRef.get();

    Map<String, dynamic>? parkingHistoryData = dataSnapshot.value as Map<String, dynamic>?;
    if(parkingHistoryData == null) return null;
  
    List<String> registrations = [];
    parkingHistoryData.forEach((parkingType, occurrences) {
    if (occurrences is List) {
      for (var occurrence in occurrences) {
        if (occurrence is Map) {
          occurrence.forEach((dateTimeString, entry) {
            if (entry is Map) {
              String registration = entry['registration'].toString() ?? "";
              registrations.add(registration);
            }
          });
        }
      }
    }
  });
    return registrations;
}


Future<List<ParkingHistoryRecord>?> getParkingHistoryData() async {
  DataSnapshot dataSnapshot = await _dbRef.get();
  Map<String, dynamic>? parkingHistoryData = dataSnapshot.value as Map<String, dynamic>?;

  if (parkingHistoryData == null) return null;

  List<ParkingHistoryRecord> parkingHistory = [];

  parkingHistoryData.forEach((parkingType, occurrences) {
    if (occurrences is List) {
      for (var occurrence in occurrences) {
        if (occurrence is Map) {
          occurrence.forEach((dateTimeString, entry) {
            if (entry is Map) {
              String registration = entry['registration'].toString() ?? "";
              DateTime parkingEnd = DateTime.parse(entry['parkingEnded'].toString());
              DateTime parkingStart = DateTime.parse(entry['parkingStarted'].toString());
              double cost = entry['income'] ?? 0.0;
              String spotId = entry['spot'].toString() ?? "";
              getBrand(registration).then((vehicleBrand) {
                parkingHistory.add(ParkingHistoryRecord(
                  vehicleRegistration: registration,
                  vehicleBrand: vehicleBrand,
                  parkingName: parkingType,
                  spotId: spotId,
                  parkingStart: parkingStart,
                  parkingEnd: parkingEnd,
                  cost: cost,
                ));
              });
            }
          });
        }
      }
    }
  });

  return parkingHistory;
}

  Future<String> getBrand(String registration) async {
    Car? car = await userService.getCarByRegistration(registration);
    if(car == null) return "Not avaible";
    return car.brand;
  }

  Future<SpotDb?> getSpotFromParking(String parkingName, int spotName) async {
    DataSnapshot snapshot = await _dbRef.child(parkingName).get();
    if(snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return SpotDb.fromMap(userData);
  }


Future<double> findCarHistory(String carReg) async {
  DataSnapshot dataSnapshot = await _dbRef.get();
  double totalIncome = 0;

  Map<String, dynamic>? parkingHistoryData = dataSnapshot.value as Map<String, dynamic>?;
  if (parkingHistoryData == null) return totalIncome;

  parkingHistoryData.forEach((parkingType, occurrences) {
    if (occurrences is Map<String, dynamic>) {
      occurrences.forEach((spotId, records) {
        if (records is Map<String, dynamic>) {
          records.forEach((recordId, entry) {
            if (entry is Map<String, dynamic> && entry['registration'] == carReg) {
              totalIncome += (entry['income'] ?? 0.0); // Accumulate income
            }
          });
        }
      });
    }
  });

  return totalIncome;
}


}
