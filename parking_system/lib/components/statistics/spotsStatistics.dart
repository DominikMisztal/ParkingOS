import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/spotRecotd.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/services/park_services.dart';

class SpotsStatisticsWidget extends StatefulWidget {
  const SpotsStatisticsWidget(
      {super.key, required this.selectedParking, required this.selectedSpotId});

  final String selectedParking;
  final String selectedSpotId;
  @override
  State<SpotsStatisticsWidget> createState() => _SpotsStatisticsWidgetState(
      selectedParking: this.selectedParking,
      selectedSpotId: this.selectedSpotId);
}

class _SpotsStatisticsWidgetState extends State<SpotsStatisticsWidget> {
  ParkingServices parkingServices = ParkingServices();
  String selectedSpotId;
  String selectedParking;
  List<String> parkingNames = [];
  List<SpotRecord> spotRecords = [];
  List<String> columnNames = [
    'Parking Name',
    'Spot ID',
    'Total income',
    'Average Daily income',
    'Is taken',
    'Temporary income',
    'Parked car',
    'Parked since'
  ];
  List<String> orderingTypes = ['Asc', 'Desc'];
  String selectedOrdering = 'Asc';
  String selectedColumn = 'Parking Name';
  String selectedColumnForFiltering = 'Parking Name';
  List<ParkingDb> parkings = [];
  _SpotsStatisticsWidgetState(
      {required this.selectedParking, required this.selectedSpotId});
  var filterController = TextEditingController();

  Future<List<ParkingDb>?> getSpotRecords() async {
    List<ParkingDb>? fetchedParkings = await parkingServices.getParkings();
    if (fetchedParkings != null) {
      parkings.clear();
      spotRecords.clear();
      parkings.addAll(fetchedParkings);
      for (var parking in parkings) {
        for (var spot in parking.spots) {
          spotRecords.add(SpotRecord(
              spotId: spot.idNumber.toString(),
              parkingName: parking.name,
              isTaken: spot.date != "" ? true : false,
              totalIncome: 0,
              dailyIncome: 0,
              temporaryIncome: spot.date == ""
                  ? setTempIncome(DateTime.now(), parking.tarifs, false)
                  : setTempIncome(
                      DateTime.parse(spot.date), parking.tarifs, true),
              parkedCarRegistration: spot.registrationNumber,
              parkingStart:
                  spot.date == "" ? null : DateTime.parse(spot.date)));
        }
      }
    }
    return fetchedParkings;
  }

  double setTempIncome(
      DateTime start, Map<String, List<double>> tarifs, bool currentlyOn) {
    if (!currentlyOn) return 0;
    DateTime dateTime2 = DateTime.now();
    Duration difference = dateTime2.difference(start);
    int hoursDifference = difference.inHours;

    int timeNow = dateTime2.hour;

    MapEntry<String, List<double>> firstEntry = tarifs.entries.first;
    MapEntry<String, List<double>> secondEntry = tarifs.entries.elementAt(1);
    ;
    int key1 = int.parse(firstEntry.key);
    int key2 = int.parse(secondEntry.key);
    if (key1 < key2) {
      if (timeNow > key1) {
        //key1 = 5, key2 = 17, timeNow = 10, timeNow = 4
        if (hoursDifference < 2)
          return firstEntry.value[0];
        else if (hoursDifference < 3)
          return firstEntry.value[1];
        else
          return firstEntry.value[2];
      } else {
        if (hoursDifference < 2)
          return secondEntry.value[0];
        else if (hoursDifference < 3)
          return secondEntry.value[1];
        else
          return secondEntry.value[2];
      }
    } else {
      //key1 = 15, key2 = 4, timeNow = 3, timeNow = 4
      if (timeNow > key1 || timeNow < key2) {
        if (hoursDifference < 2)
          return firstEntry.value[0];
        else if (hoursDifference < 3)
          return firstEntry.value[1];
        else
          return firstEntry.value[2];
      } else {
        if (hoursDifference < 2)
          return secondEntry.value[0];
        else if (hoursDifference < 3)
          return secondEntry.value[1];
        else
          return secondEntry.value[2];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getSpotRecords();
    if (selectedSpotId != '' || selectedSpotId != '-1') {
      filterController.text = selectedSpotId;
      selectedColumnForFiltering = 'Spot ID';
      // to do filtering
    }

    return FutureBuilder(
      future: getSpotRecords(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading data'),
          );
        }
        return Column(children: [
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
              textEditingController.text = selectedParking;
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (_) => onFieldSubmitted(),
                decoration: const InputDecoration(
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
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(
                              option,
                              style: const TextStyle(color: Colors.white),
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
          Row(
            children: [
              const Text(
                'Order by: ',
                style: TextStyle(color: Colors.white),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              DropdownButton<String>(
                value: selectedColumn,
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColumn = newValue!;
                  });
                },
                items:
                    columnNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              DropdownButton<String>(
                value: selectedOrdering,
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOrdering = newValue!;
                  });
                },
                items:
                    orderingTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: sortTable,
                child: const Text(
                  'Sort',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Filter: ',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 200,
                child: MyCustomTextField(
                  controller: filterController,
                  labelText: 'Filter by',
                  obscureText: false,
                ),
              ),
              DropdownButton<String>(
                value: selectedColumnForFiltering,
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColumnForFiltering = newValue!;
                  });
                },
                items:
                    columnNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: filterTable,
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          SizedBox(
            height: 500,
            width: 1400,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text(
                          columnNames[0],
                          style: const TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(columnNames[1],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[2],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[3],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[4],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[5],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[6],
                                style: const TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text(columnNames[7],
                                style: const TextStyle(color: Colors.white))),
                      ],
                      rows: spotRecords.map((SpotRecord record) {
                        return DataRow(cells: [
                          DataCell(Text(record.parkingName,
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.spotId.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.totalIncome.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.dailyIncome.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.isTaken.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.parkedCarRegistration == null
                                  ? 'N/A'
                                  : record.parkedCarRegistration.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.temporaryIncome == null
                                  ? 'N/A'
                                  : record.temporaryIncome.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.parkingStart == null
                                  ? 'N/A'
                                  : record.parkingStart.toString(),
                              style: const TextStyle(color: Colors.white)))
                        ]);
                      }).toList(),
                    ),
                  );
                }),
          )
        ]);
      },
    );
  }

  void sortTable() {
    //Change to DB connection
  }

  void filterTable() {
    //change to DB connection
  }
}
