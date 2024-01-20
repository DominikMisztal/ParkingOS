import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';
import 'package:parking_system/components/statistics/parkingStatistics.dart';
import 'package:parking_system/models/statistics/parkingHistoryRecord.dart';
import 'package:parking_system/models/statistics/parkingRecord.dart';
import 'package:parking_system/models/statistics/spotRecotd.dart';
import 'package:parking_system/models/statistics/vehicleRecord.dart';

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
    'Parking spots',
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

    return Stack(alignment: AlignmentDirectional.center, children: [
      Row(children: [
        Material(
            child: Container(
                width: width,
                child: Form(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
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
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return parkingNames.where((String parking) {
                          return parking
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String value) {
                        setState(() {
                          selectedParking = value;
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        textEditingController.text = selectedParking ?? '';
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          style: TextStyle(color: Colors.white),
                          onFieldSubmitted: (_) => onFieldSubmitted(),
                          decoration: InputDecoration(
                            labelText: 'Select parking',
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected,
                          Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              height: 200.0,
                              width: width / 2,
                              child: ListView.builder(
                                padding: EdgeInsets.all(8.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option =
                                      options.elementAt(index);
                                  return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: ListTile(
                                      title: Text(
                                        option,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    ParkingStatisticsWidget(selectedParking: selectedParking)
                  ]),
                )))),
      ])
    ]);
  }
}
