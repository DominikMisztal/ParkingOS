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
}
