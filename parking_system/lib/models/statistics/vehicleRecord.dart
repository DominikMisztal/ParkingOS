class VehicleRecord {
  String vehicleRegistration;
  String vehicleBrand;
  bool isParked;
  String? parkingName;
  String? spotId;
  DateTime? parkingSince;
  double totalExpenses;

  VehicleRecord(
      {required this.vehicleRegistration,
      required this.vehicleBrand,
      required this.isParked,
      required this.totalExpenses,
      this.parkingName,
      this.spotId,
      this.parkingSince}) {}
}
