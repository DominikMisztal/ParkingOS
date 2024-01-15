import 'package:meta/meta.dart';

@immutable
class SpotDb {
  const SpotDb ({
    required this.registrationNumber,
    required this.date,
  });

 
  final String registrationNumber;
  final String date;



  Map<String, dynamic> toMap() {
    return {
      'registration_number': registrationNumber,
      'date': date,
    };
  }

  factory SpotDb.fromMap(Map<String, dynamic> map) {
    return SpotDb(
        registrationNumber: map['registrationNumber'] ?? '',
        date: map['date'] ?? '',);
  }
}