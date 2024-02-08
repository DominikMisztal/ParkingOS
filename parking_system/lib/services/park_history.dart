import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/Spot.dart';
import 'package:parking_system/models/car_model.dart';

import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/models/statistics/parkingHistoryRecord.dart';

import '../models/statistics/spotRecotd.dart';

class ParkHistory {
  UserService userService = UserService();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('parking_history');

  Future<void> addToParkingHistory(
      String parkingName,
      String spotId,
      String registration,
      DateTime parkingStarted,
      DateTime parkingEnded,
      double income) async {
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

    Map<String, dynamic>? parkingHistoryData =
        dataSnapshot.value as Map<String, dynamic>?;
    if (parkingHistoryData == null) return null;

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

  Future<List<ParkingHistoryRecord>?> getParkingHistoryData({
    String? parkingName,
    String? vehicleBrand,
    String? spotId2,
    String? registration,
    DateTime? parkingStart,
    DateTime? parkingEnd,
    double? income,
    String? orderBy,
    bool? ascending,
  }) async {
    DataSnapshot dataSnapshot = await _dbRef.get();
    Map<String, dynamic>? parkingHistoryData =
        dataSnapshot.value as Map<String, dynamic>?;

    if (parkingHistoryData == null) return null;

    List<ParkingHistoryRecord> parkingHistory = [];

    parkingHistoryData.forEach((parkingType, parkingSpots) {
      if (parkingSpots is Map<String, dynamic>) {
        parkingSpots.forEach((spotId, spotData) {
          if (spotData is Map<String, dynamic>) {
            spotData.forEach((dateTimeString, entry) {
              if (entry is Map<String, dynamic>) {
                String entryParkingName = parkingType;
                String entryVehicleBrand = entry['vehicleBrand'].toString();
                String entrySpotId = spotId;
                String entryRegistration = entry['registration'].toString();
                DateTime entryParkingStart =
                    DateTime.parse(entry['parkingStarted'].toString());
                DateTime entryParkingEnd =
                    DateTime.parse(entry['parkingEnded'].toString());
                double entryIncome = entry['income'] ?? 0.0;

                bool matchesFilter = true;
                if (parkingName != null &&
                    !entryParkingName.contains(parkingName))
                  matchesFilter = false;
                if (vehicleBrand != null &&
                    !entryVehicleBrand.contains(vehicleBrand))
                  matchesFilter = false;
                if (spotId2 != null && !entrySpotId.contains(spotId2))
                  matchesFilter = false;
                if (registration != null &&
                    !entryRegistration.contains(registration))
                  matchesFilter = false;
                if (parkingStart != null &&
                    !entryParkingStart
                        .toString()
                        .contains(parkingStart.toString()))
                  matchesFilter = false;
                if (parkingEnd != null &&
                    !entryParkingEnd.toString().contains(parkingEnd.toString()))
                  matchesFilter = false;
                if (income != null && entryIncome != income)
                  matchesFilter = false;

                if (matchesFilter) {
                  parkingHistory.add(ParkingHistoryRecord(
                    vehicleRegistration: entryRegistration,
                    parkingName: entryParkingName,
                    spotId: entrySpotId,
                    parkingStart: entryParkingStart,
                    parkingEnd: entryParkingEnd,
                    cost: entryIncome,
                  ));
                }
              }
            });
          }
        });
      }
    });

    if (orderBy != null) {
      parkingHistory.sort((a, b) {
        dynamic aValue, bValue;
        switch (orderBy) {
          case 'Parking Name':
            aValue = a.parkingName;
            bValue = b.parkingName;
            break;
          case 'Spot ID':
            aValue = a.spotId;
            bValue = b.spotId;
            break;
          case 'Vehicle Registration':
            aValue = a.vehicleRegistration;
            bValue = b.vehicleRegistration;
            break;
          case 'Parking Start':
            aValue = a.parkingStart;
            bValue = b.parkingStart;
            break;
          case 'Parking End':
            aValue = a.parkingEnd;
            bValue = b.parkingEnd;
            break;
          case 'Payment':
            aValue = a.cost;
            bValue = b.cost;
            break;
          default:
            // Default case if orderBy parameter is invalid
            aValue = null;
            bValue = null;
            break;
        }
        // Compare values based on the specified order
        if (aValue == null && bValue == null) {
          return 0;
        } else if (aValue == null) {
          return ascending! ? 1 : -1;
        } else if (bValue == null) {
          return ascending! ? -1 : 1;
        } else {
          if (aValue is Comparable && bValue is Comparable) {
            int comparison = aValue.compareTo(bValue);
            return ascending! ? comparison : -comparison;
          } else {
            return 0;
          }
        }
      });
    }

    return parkingHistory;
  }

  Future<String> getBrand(String registration) async {
    Car? car = await userService.getCarByRegistration(registration);
    if (car == null) return "Not avaible";
    return car.brand;
  }

  Future<SpotDb?> getSpotFromParking(String parkingName, int spotName) async {
    DataSnapshot snapshot = await _dbRef.child(parkingName).get();
    if (snapshot.value == null) return null;
    Map<String, dynamic> userData = json.decode(json.encode(snapshot.value));
    return SpotDb.fromMap(userData);
  }

  Future<double> findCarHistory(String carReg) async {
    DataSnapshot dataSnapshot = await _dbRef.get();
    double totalIncome = 0;

    Map<String, dynamic>? parkingHistoryData =
        dataSnapshot.value as Map<String, dynamic>?;
    if (parkingHistoryData == null) return totalIncome;

    parkingHistoryData.forEach((parkingType, occurrences) {
      if (occurrences is Map<String, dynamic>) {
        occurrences.forEach((spotId, records) {
          if (records is Map<String, dynamic>) {
            records.forEach((recordId, entry) {
              if (entry is Map<String, dynamic> &&
                  entry['registration'] == carReg) {
                totalIncome += (entry['income'] ?? 0.0); // Accumulate income
              }
            });
          }
        });
      }
    });

    return totalIncome;
  }

  Future<SpotRecord> setIncomeForSpot(SpotRecord temp) async {
    DataSnapshot dataSnapshot = await _dbRef.get();
    double totalIncome = 0;

    Map<String, dynamic>? parkingHistoryData =
        dataSnapshot.value as Map<String, dynamic>?;
    if (parkingHistoryData == null) return temp;

    parkingHistoryData.forEach((parkingType, occurrences) {
      if (occurrences is Map<String, dynamic> &&
          parkingType == temp.parkingName) {
        occurrences.forEach((spotId, records) {
          if (records is Map<String, dynamic>) {
            records.forEach((recordId, entry) {
              if (entry is Map<String, dynamic> &&
                  entry['spot'] == temp.spotId) {
                temp.totalIncome += (entry['income'] ?? 0.0);
                DateTime now = DateTime.now();
                DateTime check = DateTime.parse(entry['parkingEnded']);
                if (check.day == now.day &&
                    check.month == now.month &&
                    check.year == now.year) {
                  temp.dailyIncome += (entry['income'] ?? 0.0);
                }
              }
            });
          }
        });
      }
    });

    return temp;
  }
}
