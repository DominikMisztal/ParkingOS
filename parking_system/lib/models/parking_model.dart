class Parking {
  String parkingId;
  String name;
  String adress;
  int floors;
  int spotPerFloor;
  double price; //change to something more sophisticated

  Parking(this.parkingId, this.name, this.adress, this.floors,
      this.spotPerFloor, this.price);

  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'name': name,
      'adress': adress,
      'floors': floors,
      'spotPerFloor': spotPerFloor,
    };
  }

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      map['parkingId'] ?? '',
      map['name'] ?? '',
      map['adress'] ?? '',
      map['floors'] ?? 0,
      map['spotPerFloor'] ?? 0,
      map['price'] ?? 0,
    );
  }
}
