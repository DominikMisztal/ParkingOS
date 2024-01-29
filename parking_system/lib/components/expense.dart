class Expense {
  String type;
  bool cyclical;
  double amount;
  DateTime dateAdded;

  Expense(this.type, this.cyclical, this.amount, this.dateAdded);

  @override
  String toString() {
    return 'Type: $type; Amount: ${amount.toStringAsFixed(2)}; Cyclical: ${cyclical ? 'Yes' : 'No'}';
  }

  
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'cyclical': cyclical,
      'amount': amount,
      'dateAdded': dateAdded.toIso8601String(), // Convert DateTime to string
    };
  }


  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      map['type'],
      map['cyclical'],
      map['amount'],
      DateTime.parse(map['dateAdded']), // Parse string to DateTime
    );
  }

}
