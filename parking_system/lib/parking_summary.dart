import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ParkingSummary extends StatefulWidget {
  const ParkingSummary({super.key});

  @override
  State<ParkingSummary> createState() => _ParkingSummaryState();
}

class _ParkingSummaryState extends State<ParkingSummary> {
  List<ChartData> incomeData = [];
  List<ChartData> expenseData = [];
  List<String> parkingNames = [];
  List<String> chartTypes = ['Column chart', 'Line chart'];
  String selectedParking = '';
  String selectedChartType = 'Column chart';

  void getParkingNames() {
    List<String> temp = [];
    temp.add('Parking 1');
    temp.add('Parking 2');
    temp.add('Parking 3');
    parkingNames = temp;
    selectedParking = parkingNames[0];
  }

  _ParkingSummaryState() {
    getParkingNames();
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
    getChartData();

    if (selectedChartType == 'Column chart') {
      return Stack(alignment: AlignmentDirectional.center, children: [
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
                                selectedParking = newValue!;
                              });
                            },
                            items: parkingNames
                                .map<DropdownMenuItem<String>>((String value) {
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
                            items: chartTypes
                                .map<DropdownMenuItem<String>>((String value) {
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
      ]);
    } else {
      return Stack(alignment: AlignmentDirectional.center, children: [
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
                                selectedParking = newValue!;
                              });
                            },
                            items: parkingNames
                                .map<DropdownMenuItem<String>>((String value) {
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
                            items: chartTypes
                                .map<DropdownMenuItem<String>>((String value) {
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
      ]);
    }

    // return Scaffold(
    //     body: Column(
    //   children: [
    //     SizedBox(
    //       height: 150,
    //       child: Row(
    //         children: [
    //           ElevatedButton(
    //             onPressed: () => {Navigator.pop(context)},
    //             child: Text(
    //               'Go back',
    //               style: TextStyle(
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           Padding(padding: EdgeInsets.all(10)),
    //           Material(
    //             child: DropdownButton<String>(
    //               value: selectedParking,
    //               style: TextStyle(color: Colors.white),
    //               onChanged: (String? newValue) {
    //                 setState(() {
    //                   selectedParking = newValue!;
    //                 });
    //               },
    //               items: parkingNames
    //                   .map<DropdownMenuItem<String>>((String value) {
    //                 return DropdownMenuItem<String>(
    //                   value: value,
    //                   child: Text(value),
    //                 );
    //               }).toList(),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //         height: 500,
    //         width: width * 0.8,
    //         child: SfCartesianChart(
    //           legend: Legend(isVisible: true),
    //           primaryXAxis: CategoryAxis(),
    //           series: <ColumnSeries<ChartData, String>>[
    //             ColumnSeries<ChartData, String>(
    //               dataSource: incomeData,
    //               xValueMapper: (ChartData data, _) => data.x,
    //               yValueMapper: (ChartData data, _) => data.y,
    //               name: 'Income',
    //             ),
    //             ColumnSeries<ChartData, String>(
    //               dataSource: expenseData,
    //               xValueMapper: (ChartData data, _) => data.x,
    //               yValueMapper: (ChartData data, _) => data.y,
    //               name: 'Expense',
    //             ),
    //           ],
    //         ))
    //   ],
    // ));
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
