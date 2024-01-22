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
    required this.income,
    required this.dailyIncome,
  });

  final Map<String, List<double>> tarifs;
  final String name;
  final List<SpotDb> spots;
  final String address;
  final int height;
  final int width;
  final int level;
  final double income;
  final double dailyIncome;

  Map<String, dynamic> toMap() {
    return {
      'tarifs': tarifs,
      'name': name,
      'spots': spots.map((spot) => spot.toMap()).toList(),
      'address': address,
      'height': height,
      'width': width,
      'level': level,
      'income': income,
      'dailyIncome': dailyIncome,
    };
  }

  factory ParkingDb.fromMap(Map<String, dynamic> map) {
  if (map == null) {
    throw ArgumentError("Input map cannot be null");
  }

  return ParkingDb(
    tarifs: _parseTarifs(map['tarifs']),
    name: map['name'] is String ? map['name'] : '',
    address: map['address'] is String ? map['address'] : '',
    width: (map['width'] is num) ? map['width'].toDouble() : 0.0,
    level: (map['level'] is num) ? map['level'].toInt() : 0,
    income: (map['income'] is num) ? map['income'].toDouble() : 0.0,
    dailyIncome: (map['dailyIncome'] is num) ? map['dailyIncome'].toDouble() : 0.0,
    height: (map['height'] is num) ? map['height'].toDouble() : 0.0,
    spots: (map['spots'] is List)
        ? List<SpotDb>.from((map['spots'] as List).map(
            (spotMap) => SpotDb.fromMap(spotMap as Map<String, dynamic>),
          ))
        : [],
  );
}

static Map<String, List<double>> _parseTarifs(dynamic tarifs) {
    if (tarifs == null || tarifs is! Map) {
      return {};
    }

    Map<String, List<double>> parsedTarifs = {};

    (tarifs as Map<String, dynamic>).forEach((key, value) {
      if (value is List && value.every((element) => element is num)) {
        parsedTarifs[key] = List<double>.from(value.map((element) => element.toDouble()));
      }
    });

    return parsedTarifs;
  }

}