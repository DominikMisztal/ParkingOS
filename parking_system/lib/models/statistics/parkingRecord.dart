class ParkingRecord {
  String parkingName;
  int amountOfSpots;
  int takenSpots;
  double totalIncome;
  double todayIncome;

  ParkingRecord(
      {required this.parkingName,
      required this.amountOfSpots,
      required this.takenSpots,
      required this.todayIncome,
      required this.totalIncome});
}
