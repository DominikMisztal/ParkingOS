import 'package:flutter/material.dart';
import 'package:parking_system/components/statistics/parkingStatistics.dart';
import 'package:parking_system/components/statistics/vehicleStatistics.dart';
import 'package:parking_system/models/statistics/parkingHistoryRecord.dart';
import 'package:parking_system/models/statistics/parkingRecord.dart';
import 'package:parking_system/models/statistics/spotRecotd.dart';
import 'package:parking_system/models/statistics/vehicleRecord.dart';

import 'components/statistics/historyStatistics.dart';
import 'components/statistics/spotsStatistics.dart';

class ParkingStatistics extends StatefulWidget {
  const ParkingStatistics(
      {super.key,
      required this.category,
      required this.parkingName,
      required this.spotId,
      required this.vehicleReg});

  final String category;
  final String parkingName;
  final String spotId;
  final String vehicleReg;

  @override
  State<ParkingStatistics> createState() => _ParkingStatisticsState(
      selectedCategory: category,
      selectedParking: parkingName,
      selectedSpot: spotId,
      selectedVehicle: vehicleReg);
}

class _ParkingStatisticsState extends State<ParkingStatistics> {
  String selectedParking;
  String selectedVehicle;
  String selectedSpot;
  String selectedCategory;
  List<String> categories = [
    'Parkings',
    'Parking Spots',
    'Vehicles',
    'Parking History'
  ];
  List<String> spotIds = [];
  List<String> cars = [];

  List<ParkingRecord> parkingsRecords = [];
  List<VehicleRecord> vehiclesRecords = [];
  List<SpotRecord> spotsRecords = [];
  List<ParkingHistoryRecord> historyRecords = [];

  final vehicleBrandController = TextEditingController();

  List<String> parkingNames = [];
  _ParkingStatisticsState(
      {required this.selectedCategory,
      required this.selectedParking,
      required this.selectedSpot,
      required this.selectedVehicle}) {
    getParkingData();
  }

  void getParkingData() {
    //DB connection TO DO
    parkingNames.add("Parking 1");
    parkingNames.add("Parking 2");
    parkingNames.add("Parking 3");
    for (var i = 0; i < 100; i++) {
      spotIds.add(i.toString());
      cars.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (selectedCategory == 'Parkings') {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Statistics'),
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
                          Padding(padding: EdgeInsets.all(10)),
                          ParkingStatisticsWidget(
                              selectedParking: selectedParking)
                        ]),
                      )))),
            ])
          ]));
    } else if (selectedCategory == 'Parking Spots') {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Statistics'),
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
                          Padding(padding: EdgeInsets.all(10)),
                          SpotsStatisticsWidget(
                              selectedParking: selectedParking,
                              selectedSpotId: selectedSpot)
                        ]),
                      )))),
            ])
          ]));
    } else if (selectedCategory == 'Vehicles') {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Statistics'),
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
                          Padding(padding: EdgeInsets.all(10)),
                          VehicleStatisticsWidget(
                              selectedParking: selectedParking)
                        ]),
                      )))),
            ])
          ]));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Parking Statistics'),
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
                          Padding(padding: EdgeInsets.all(10)),
                          HistoryStatisticsWidget(
                              selectedParking: selectedParking)
                        ]),
                      )))),
            ])
          ]));
    }
  }
}
