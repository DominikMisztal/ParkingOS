class Parking {
  String name;
  int floors;
  int spot_for_floor;

  Parking(this.name, this.floors, this.spot_for_floor);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'floors': floors,
      'spot_for_floor': spot_for_floor,
    };
  }

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      map['name'] ?? '',
      map['floors'] ?? 0,
      map['spot_for_floor'] ?? 0,
    );
  }
}
