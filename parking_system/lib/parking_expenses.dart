import 'package:flutter/material.dart';
import 'package:parking_system/components/expense.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/expenses_services.dart';

class ParkingExpenses extends StatefulWidget {
  const ParkingExpenses({super.key});

  @override
  State<ParkingExpenses> createState() => _ParkingExpensesrState();
}

class _ParkingExpensesrState extends State<ParkingExpenses> {
  ParkingServices parkingServices = ParkingServices();
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  List<String> parkingNames = ['Parking 1', 'Parking 2'];
  late String selectedParking;
  String expensesLabel = 'Expenses for ';
  List<Expense> expensesRecords = [];
  ExpensesServices expensesServices = ExpensesServices();
  int selecterParkingIndex = 0;

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
  List<List<Expense>?> loadExpensesForParkings = [];

  Future<List<String>?> getParkings() async {
    List<String>? tempParkingNames = await parkingServices.getParkingNames();
    parkingNames.clear();
    if (tempParkingNames == null) return null;
    for (String parkingName in tempParkingNames) {
      if (!parkingNames.contains(parkingName)) {
        parkingNames.add(parkingName);
      }
    }
    for (var park in tempParkingNames) {
      List<Expense>? tempExpenses =
          await expensesServices.loadExpensesForParking(park);
      loadExpensesForParkings.add(tempExpenses);
    }
    Future.delayed(Duration(seconds: 2));
    print(loadExpensesForParkings);
    selectedParking = parkingNames[selecterParkingIndex];
    return tempParkingNames;
  }

  void saveExpenses(String name, List<Expense> expenses) {
    expensesServices.saveExpensesForParking(name, expenses);
  }

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
  void initState() {
    super.initState();
    getParkings();
  }

  int selectedPark = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    selectedParking = parkingNames[selectedPark];
    changeExpenses();
    updateListView();
    expensesLabel = 'Expenses for ${selectedDate.month}.${selectedDate.year}';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Parking Expenses'),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: [
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
                            ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text(
                                'Go back',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            const Text(
                              'Date: ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            FutureBuilder(
                              future: getParkings(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return DropdownButton<String>(
                                  value: selectedParking,
                                  style: TextStyle(color: Colors.white),
                                  onChanged: (String? newValue) {
                                    selectedPark =
                                        parkingNames.indexOf(newValue!);
                                    setState(() {
                                      selectedParking = newValue!;
                                    });
                                  },
                                  items: parkingNames
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                );
                              },
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
                          onPressed: addExpenseToParking,
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        ElevatedButton(
                          onPressed: saveChanges,
                          child: Text(
                            'Save changes',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ]),
                    )))),
            Container(
              width: (width / 2),
              child: Scaffold(
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
                    child: FutureBuilder(
                      future: getParkings(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error loading data'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _items[index];
                              return Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  setState(() {
                                    expensesRecords.removeAt(index);
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
                                        expensesRecords.removeAt(index);
                                        _items.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              )),
            )
          ])
        ]));
  }

  void addExpenseToParking() {
    setState(() {
      loadExpensesForParkings[selectedPark]!.add(Expense(
          selectedCategory,
          isCyclical,
          double.parse(expenseAmountController.text),
          selectedDate));
    });
  }

  void updateListView() {
    List<String> newList = [];
    for (var x in expensesRecords) {
      newList.add(x.toString());
    }
    _items = newList;
  }

  void addExpenses() {
    //get expenses from database
    if (expensesRecords.isEmpty) {
      List<Expense> temp = [];
      temp.add(Expense('Cleaning', false, 120.50, DateTime.now()));
      temp.add(Expense('Other', false, 40.75, DateTime.now()));
      temp.add(Expense('Electricity', true, 202, DateTime.now()));
      expensesRecords = temp;
    }
  }

  void changeExpenses() {
    //get expenses from database
    if (loadExpensesForParkings.isEmpty) return;
    List<Expense> temp = [];
    for (var expense in loadExpensesForParkings[selectedPark]!) {
      if ((expense.dateAdded.month == selectedDate.month &&
              expense.dateAdded.year == selectedDate.year) ||
          (expense.cyclical == true &&
              expense.dateAdded.isBefore(selectedDate))) {
        temp.add(expense);
      }
      expensesRecords = temp;
    }
  }

  void saveChanges() {
    saveExpenses(selectedParking, expensesRecords);
    //send expensesRecords to database
  }
}
