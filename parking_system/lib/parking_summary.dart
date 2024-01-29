import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parking_system/components/expense.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/expenses_services.dart';

class ParkingSummary extends StatefulWidget {
  const ParkingSummary({super.key});

  @override
  State<ParkingSummary> createState() => _ParkingSummaryState();
}

class _ParkingSummaryState extends State<ParkingSummary> {
  ParkingServices parkingServices = ParkingServices();
  ExpensesServices  expenseServices = ExpensesServices();
  List<ChartData> incomeData = [];
  List<ChartData> expenseData = [];
  List<String> parkingNames = [];
  List<String> chartTypes = ['Column chart', 'Line chart'];
  String selectedParking = '';
  String selectedChartType = 'Column chart';
  List<List<Expense>> expenses = [];
  void getParkingNames() {
    List<String> temp = [];
    temp.add('Parking 1');
    temp.add('Parking 2');
    temp.add('Parking 3');
    parkingNames = temp;
    selectedParking = parkingNames[0];
  }
  
  void setParkingNames() async{
    List<String>? temp = await parkingServices.getParkingNames();
    if(temp == null) return;
    parkingNames.addAll(temp);
    selectedParking = parkingNames[0];
  }
  
  

  @override
  void initState() {
    super.initState();
    setParkingNames();
    getExpenses();
    //getIncome();
  }

  void getExpenses() async{
    for (var name in parkingNames) {
      List<Expense> tempExpense = await expenseServices.loadExpensesForParking(name);
      expenses.add(tempExpense);
    }
  }
  
  _ParkingSummaryState() {
    getParkingNames();
  }
  int selectedPark = 0;


  void getDataToCharts() {
    List<ChartData> incomeTemp = [];
    List<ChartData> expensesTemp = [];
    
    if(expenses.isEmpty) return;
    print(selectedPark);
      double amount = 0;
      for (var expense in expenses[selectedPark]){
        if((expense.dateAdded.month == 11 && expense.dateAdded.year == DateTime.now().year - 1) || (expense.dateAdded.isBefore(DateTime.now()) && expense.cyclical == true)){
          amount += expense.amount;
        }
      }
      expensesTemp.add(ChartData("11", amount));
      amount = 0;
      for (var expense in expenses[selectedPark]){
        if((expense.dateAdded.month == 12 && expense.dateAdded.year == DateTime.now().year - 1) || (expense.dateAdded.isBefore(DateTime.now()) && expense.cyclical == true)){
            amount += expense.amount;
        }
      }
      expensesTemp.add(ChartData("12", amount));
      amount = 0;
      for (var expense in expenses[selectedPark]){
        if((expense.dateAdded.month == DateTime.now().month && expense.dateAdded.year == DateTime.now().year) || (expense.dateAdded.isBefore(DateTime.now()) && expense.cyclical == true)){
            amount += expense.amount;
        }
      }
      expensesTemp.add(ChartData("1", amount));
    
    

    incomeTemp.add(ChartData("11", Random().nextInt(100) + 50));
    incomeTemp.add(ChartData("12", Random().nextInt(100) + 50));
    incomeTemp.add(ChartData("1", Random().nextInt(100) + 50));
    incomeData = incomeTemp;
    expenseData = expensesTemp;
  }

  void getChartData() {
    List<ChartData> incomeTemp = [];
    List<ChartData> expensesTemp = [];

    incomeTemp.add(ChartData("January", Random().nextInt(100) + 300));
    incomeTemp.add(ChartData("February", Random().nextInt(100) + 300));
    incomeTemp.add(ChartData("March", Random().nextInt(100) + 300));

    expensesTemp.add(ChartData("January", Random().nextInt(100) + 300));
    expensesTemp.add(ChartData("February", Random().nextInt(100) + 300));
    expensesTemp.add(ChartData("March", Random().nextInt(100) + 300));
    incomeData = incomeTemp;
    expenseData = expensesTemp;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    getDataToCharts();

    if (selectedChartType == 'Column chart') {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Summary'),
          ),
          body: Stack(alignment: AlignmentDirectional.center, children: [
            Row(children: [
              Material(
                  child: Container(
                      width: width,
                      child: Form(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => {Navigator.pop(context)},
                                child: Text(
                                  'Go back',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              DropdownButton<String>(
                                value: selectedParking,
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPark = parkingNames.indexOf(newValue!);
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
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              DropdownButton<String>(
                                value: selectedChartType,
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedChartType = newValue!;
                                  });
                                },
                                items: chartTypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              height: 500,
                              width: width * 0.8,
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    textStyle: TextStyle(color: Colors.white)),
                                primaryXAxis: CategoryAxis(),
                                series: <ColumnSeries<ChartData, String>>[
                                  ColumnSeries<ChartData, String>(
                                    dataSource: incomeData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    name: 'Income',
                                  ),
                                  ColumnSeries<ChartData, String>(
                                    dataSource: expenseData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    name: 'Expense',
                                  ),
                                ],
                              ))
                        ]),
                      )))),
            ])
          ]));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Summary'),
          ),
          body: Stack(alignment: AlignmentDirectional.center, children: [
            Row(children: [
              Material(
                  child: Container(
                      width: width,
                      child: Form(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => {Navigator.pop(context)},
                                child: Text(
                                  'Go back',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              DropdownButton<String>(
                                value: selectedParking,
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPark = parkingNames.indexOf(newValue!);
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
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              DropdownButton<String>(
                                value: selectedChartType,
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedChartType = newValue!;
                                  });
                                },
                                items: chartTypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              height: 500,
                              width: width * 0.8,
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    textStyle: TextStyle(color: Colors.white)),
                                primaryXAxis: CategoryAxis(),
                                series: <LineSeries<ChartData, String>>[
                                  LineSeries<ChartData, String>(
                                    dataSource: incomeData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    name: 'Income',
                                  ),
                                  LineSeries<ChartData, String>(
                                    dataSource: expenseData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    name: 'Expense',
                                  ),
                                ],
                              ))
                        ]),
                      )))),
            ])
          ]));
    }
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
