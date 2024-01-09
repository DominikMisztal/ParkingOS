class Parking {
  String name;
  String adress;
  int floors;
  int spotPerFloor;

  Parking(this.name, this.adress, this.floors, this.spotPerFloor);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'adress': adress,
      'floors': floors,
      'spotPerFloor': spotPerFloor,
    };
  }

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      map['name'] ?? '',
      map['adress'] ?? '',
      map['floors'] ?? 0,
      map['spotPerFloor'] ?? 0,
    );
  }
}
