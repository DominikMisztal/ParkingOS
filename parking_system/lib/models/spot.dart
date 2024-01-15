import 'package:meta/meta.dart';

@immutable
class SpotDb {
  const SpotDb ({
    required this.id,
    required this.avaibility,
    required this.date,
  });

  final String id;
  final String avaibility;
  final String date;



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avaibility': avaibility,
      'date': date,
    };
  }

  factory SpotDb.fromMap(Map<String, dynamic> map) {
    return SpotDb(
        id: map['id'] ?? '',
        avaibility: map['avaibility'] ?? '',
        date: map['avaibility'] ?? '',);
  }
}