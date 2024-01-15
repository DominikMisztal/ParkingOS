import 'package:meta/meta.dart';
import 'package:parking_system/models/spot.dart';

@immutable
class ParkingDb {
  const ParkingDb ({
    required this.name,
    required this.spots,
  });

  final String name;
  final List<SpotDb> spots;



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'SpotDb': SpotDb,
    };
  }

  factory ParkingDb.fromMap(Map<String, dynamic> map) {
    return ParkingDb(
        name: map['name'] ?? '',
        spots: List<SpotDb>.from(map['spots'] ?? []));
  }
}