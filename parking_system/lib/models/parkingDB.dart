import 'package:meta/meta.dart';
import 'package:parking_system/models/spot.dart';

@immutable
class ParkingDb {
  const ParkingDb ({
    required this.name,
    required this.height,
    required this.width,
    required this.level,
    required this.spots,
    required this.address,
    required this.tarifs,
  });

  final Map<String, List<double>> tarifs;
  final String name;
  final List<SpotDb> spots;
  final String address;
  final int height;
  final int width;
  final int level;

  Map<String, dynamic> toMap() {
    return {
      'tarifs': tarifs,
      'name': name,
      'spots': spots.map((spot) => spot.toMap()).toList(),
      'address': address,
      'height': height,
      'width': width,
      'level': level,
    };
  }

  factory ParkingDb.fromMap(Map<String, dynamic> map) {
    return ParkingDb(
        tarifs: map['tarifs'] ?? {},
        name: map['name'] ?? '',
        address: map['address'] ?? '',
        width: map['width'] ?? 0,
        level: map['level'] ?? 0,
        height: map['height'] ?? 0,
        spots: List<SpotDb>.from(map['spots'] ?? []));
  }
}