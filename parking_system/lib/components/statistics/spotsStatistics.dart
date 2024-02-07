import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/spotRecotd.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/services/park_history.dart';
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
  ParkHistory parkHistory = ParkHistory();
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
    'Parked car',
    'Temporary income',
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
  bool firstLoad = true;

  Future<List<ParkingDb>?> getSpotRecords() async {

  List<ParkingDb>? fetchedParkings = null;
    bool ascending = selectedOrdering == "Asc" ? true : false;
    if (filterController.text != "") {
      if (selectedColumnForFiltering == "Amount of Spots") {
        fetchedParkings = await parkingServices.getParkings(
            amountOfSpots: int.tryParse(filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Parking Name") {
        fetchedParkings = await parkingServices.getParkings(
            parkingName: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      }
      else {
        fetchedParkings = await parkingServices.getParkings(
            sortBy: selectedColumn, asc: ascending);
      }
    } else {
      fetchedParkings = await parkingServices.getParkings(
          sortBy: selectedColumn, asc: ascending);
    }

    if (fetchedParkings != null) {
      parkings.clear();
      spotRecords.clear();
      parkings.addAll(fetchedParkings);
      for (var parking in parkings) {
        for (var spot in parking.spots) {
          SpotRecord tempSpot = (SpotRecord(
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
        tempSpot = await setTotalSpotIncomeAndDailyIncome(tempSpot);
        

        if(shouldAdd(tempSpot)){
          spotRecords.add(tempSpot);
          }
        }
      }
    }
    spotRecords = removeDuplicates(spotRecords);
    return fetchedParkings;
  }


  List<SpotRecord> removeDuplicates(List<SpotRecord> cars) {
    Map<String, String> seenRegistrations = Map<String, String>();
    List<SpotRecord> filteredCars = [];

    for (SpotRecord car in cars) {
      bool shouldAdd = true;
      for (var key in seenRegistrations.keys) {{
        if (key == car.spotId && seenRegistrations[key] == car.parkingName) {
          shouldAdd = false;
      }};   
    }
    if(shouldAdd){
        filteredCars.add(car);
        seenRegistrations[car.spotId] = car.parkingName;
      }
    }
    return filteredCars;
  }



  Future<SpotRecord> setTotalSpotIncomeAndDailyIncome(SpotRecord temp) async {
    SpotRecord spot = await parkHistory.setIncomeForSpot(temp);
    return spot;
  }


  bool shouldAdd(SpotRecord spot){
    if (filterController.text != "") {
      if (selectedColumnForFiltering == "Parking Name") {
         if(spot.parkingName.contains(filterController.text)) return true;
      }
      else if (selectedColumnForFiltering == "Spot ID") {
         if(spot.spotId == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Total income") {
         if(spot.totalIncome.toString() == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Average Daily income") {
         if(spot.dailyIncome.toString() == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Is taken") {
         if(spot.isTaken.toString() == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Parked car") {
         if(spot.parkedCarRegistration.toString() == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Temporary income") {
         if(spot.temporaryIncome.toString() == filterController.text) return true;
      }
      else if (selectedColumnForFiltering == "Parked since") {
         if(spot.parkingStart.toString().contains(filterController.text)) return true;
      }
    return false;
    }
    else{
    return true;
    }
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
    // if (firstLoad && selectedSpotId == '') {
    //   filterController.text = selectedSpotId;
    //   selectedColumnForFiltering = 'Spot ID';
    //   // to do filtering
    // }

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
            height: 650,
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
