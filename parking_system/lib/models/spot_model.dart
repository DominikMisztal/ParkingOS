class Spot {
  String parkingId;
  int floor;
  int number;
  bool isTaken;

  Spot(this.parkingId, this.floor, this.number, this.isTaken);

  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'floor': floor,
      'number': number,
      'isTaken': isTaken,
    };
  }

  factory Spot.fromMap(Map<String, dynamic> map) {
    return Spot(
      map['parkingId'] ?? '',
      map['floor'] ?? 0,
      map['number'] ?? 0,
      map['isTaken'] ?? false,
    );
  }
}
