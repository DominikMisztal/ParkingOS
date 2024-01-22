import 'package:meta/meta.dart';

@immutable
class SpotDb {
  const SpotDb ({
    required this.registrationNumber,
    required this.date,
    required this.level,
    required this.idNumber,
  });

 
  final String registrationNumber;
  final String date;
  final int level;
  final int idNumber;



  Map<String, dynamic> toMap() {
    return {
      'registration_number': registrationNumber,
      'date': date,
      'level': level,
      'idNumber': idNumber,
    };
  }

  factory SpotDb.fromMap(Map<String, dynamic> map) {
    return SpotDb(
        registrationNumber: map['registrationNumber'] ?? '',
        date: map['date'] ?? '',
        level: map['level'] ?? '',
        idNumber: map['idNumber'] ?? '',);
  }
}