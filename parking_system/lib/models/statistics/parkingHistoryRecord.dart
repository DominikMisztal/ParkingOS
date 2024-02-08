class ParkingHistoryRecord {
  String vehicleRegistration;
  String parkingName;
  String spotId;
  DateTime parkingStart;
  DateTime parkingEnd;
  double cost;

  ParkingHistoryRecord(
      {required this.vehicleRegistration,
      required this.parkingName,
      required this.spotId,
      required this.parkingStart,
      required this.parkingEnd,
      required this.cost});
}
