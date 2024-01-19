import 'package:flutter/material.dart';
import 'package:parking_system/components/expense.dart';

class ParkingCurrentExpenses extends StatefulWidget {
  const ParkingCurrentExpenses({super.key, required this.selectedDate});
  final DateTime selectedDate;
  @override
  State<ParkingCurrentExpenses> createState() =>
      _ParkingCurrentExpensesState(selectedDate: this.selectedDate);
}

class _ParkingCurrentExpensesState extends State<ParkingCurrentExpenses> {
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  String expensesLabel = 'Expenses for ';
  List<Expense> expensesRecords = [];
  final DateTime selectedDate;
  _ParkingCurrentExpensesState({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    addExpenses();
    updateListView();
    expensesLabel = 'Expenses for ${selectedDate.month}.${selectedDate.year}';
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
          child: Text(
            expensesLabel,
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _items[index];
              return Dismissible(
                key: Key(item),
                onDismissed: (direction) {
                  setState(() {
                    _items.removeAt(index);
                  });
                },
                child: ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }

  void addExpenses() {
    //get expenses from database
    expensesRecords.add(Expense('Cleaning', false, 120.50, DateTime.now()));
    expensesRecords.add(Expense('Other', false, 40.75, DateTime.now()));
    expensesRecords.add(Expense('Electricity', true, 202, DateTime.now()));
  }

  void updateListView() {
    List<String> newList = [];
    for (var x in expensesRecords) {
      newList.add(x.toString());
    }
    _items = newList;
  }

  void removeRecord(index) {}
}
