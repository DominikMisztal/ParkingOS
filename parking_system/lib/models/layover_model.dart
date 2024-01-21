//Spytać się jak to robimy

import 'package:parking_system/models/car_model.dart';

class Layover {
  final String startDate;
  String endDate = '';
  final String parkingId;
  final String spotId;
  final Car car;

  Layover(this.startDate, this.endDate, this.parkingId, this.spotId, this.car);

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'parkingId': parkingId,
      'spotId': spotId,
      'car': car,
    };
  }

  factory Layover.fromMap(Map<String, dynamic> map) {
    return Layover(
      map['startDate'],
      map['endDate'] ?? '',
      map['parkingId'],
      map['spotId'],
      map['car'],
    );
  }
}
