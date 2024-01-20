class SpotRecord {
  String spotId;
  String parkingName;
  bool isTaken;
  double totalIncome;
  double dailyIncome;
  double temporaryIncome;
  String? parkedCarRegistration;
  DateTime? takenSince;

  SpotRecord(
      {required this.spotId,
      required this.parkingName,
      required this.isTaken,
      required this.totalIncome,
      required this.dailyIncome,
      required this.temporaryIncome,
      this.parkedCarRegistration,
      this.takenSince}) {}
}
