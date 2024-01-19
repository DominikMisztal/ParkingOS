import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/components/parking_current_expenses.dart';

class ParkingExpenses extends StatefulWidget {
  const ParkingExpenses({super.key});

  @override
  State<ParkingExpenses> createState() => _ParkingExpensesrState();
}

class _ParkingExpensesrState extends State<ParkingExpenses> {
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Cleaning';
  final List<String> categories = [
    'Cleaning',
    'Electricity',
    'Maintenance',
    'Other'
  ];
  final expenseAmountController = TextEditingController();
  bool isCyclical = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              colorScheme:
                  Theme.of(context).colorScheme.copyWith(primary: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: height - 30,
        width: width - 30,
        color: Colors.white60,
      ),
      Row(children: [
        Material(
            child: Container(
                width: width / 2,
                child: Form(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Date: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    MyCustomTextField(
                        controller: expenseAmountController,
                        labelText: 'Amount',
                        obscureText: false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Is cyclical: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox(
                          value: isCyclical,
                          onChanged: (bool? value) {
                            setState(() {
                              isCyclical = value!;
                            });
                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your code here.
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                )))),
        Container(
          width: (width / 2),
          child: ParkingCurrentExpenses(selectedDate: DateTime.now()),
        )
      ])
    ]);
  }

  void addExpenseToParking() {}
}
