import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/parkingHistoryRecord.dart';
import 'package:parking_system/services/park_history.dart';

class HistoryStatisticsWidget extends StatefulWidget {
  const HistoryStatisticsWidget({super.key, required this.selectedParking});

  final String selectedParking;
  @override
  State<HistoryStatisticsWidget> createState() =>
      _HistoryStatisticsWidgetState(selectedParking: this.selectedParking);
}

class _HistoryStatisticsWidgetState extends State<HistoryStatisticsWidget> {
  ParkHistory parkHistory = ParkHistory();
  String selectedParking;
  List<String> parkingNames = [];
  List<ParkingHistoryRecord> historyRecords = [];
  List<String> columnNames = [
    'Parking Name',
    'Spot ID',
    'Vehicle Registration',
    'Vehicle Brand',
    'Parking Start',
    'Parking End',
    'Payment'
  ];
  List<String> orderingTypes = ['Asc', 'Desc'];
  String selectedOrdering = 'Asc';
  String selectedColumn = 'Parking Name';
  String selectedColumnForFiltering = 'Parking Name';

  _HistoryStatisticsWidgetState({required this.selectedParking});
  var filterController = TextEditingController();

  Future<List<ParkingHistoryRecord>?> getHistoryRecords() async {
    List<ParkingHistoryRecord>? temp;
    bool ascending = selectedOrdering == "Asc" ? true : false;
    if (filterController.text != "") {
      if (selectedColumnForFiltering == "Parking Name") {
        temp = await parkHistory.getParkingHistoryData(
            parkingName: (filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Spot ID") {
        temp = await parkHistory.getParkingHistoryData(
            spotId2: (filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Vehicle Registration") {
        temp = await parkHistory.getParkingHistoryData(
            registration: (filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Vehicle Brand") {
        temp = await parkHistory.getParkingHistoryData(
            vehicleBrand: filterController.text,
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Parking Start") {
        temp = await parkHistory.getParkingHistoryData(
            parkingStart: DateTime.tryParse(filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Parking End") {
        temp = await parkHistory.getParkingHistoryData(
            parkingEnd: DateTime.tryParse(filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else if (selectedColumnForFiltering == "Payment") {
        temp = await parkHistory.getParkingHistoryData(
            income: double.tryParse(filterController.text),
            orderBy: selectedColumn,
            ascending: ascending);
      } else {
        temp = await parkHistory.getParkingHistoryData(
            orderBy: selectedColumn, ascending: ascending);
      }
    } else {
      temp = await parkHistory.getParkingHistoryData(
          orderBy: selectedColumn, ascending: ascending);
    }

    if (temp != null) {
      historyRecords = temp;
      return temp;
    }
    historyRecords.add(ParkingHistoryRecord(
        vehicleRegistration: 'kl-12345',
        vehicleBrand: 'Mazda',
        parkingName: 'Parking 1',
        spotId: '123',
        parkingStart: DateTime.now(),
        parkingEnd: DateTime.now(),
        cost: 125.25));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getHistoryRecords();
    return FutureBuilder(
      future: getHistoryRecords(),
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
            width: 1400,
            height: 650,
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
                      ],
                      rows: historyRecords.map((ParkingHistoryRecord record) {
                        return DataRow(cells: [
                          DataCell(Text(record.parkingName,
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.spotId.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.vehicleRegistration.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.vehicleBrand.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.parkingStart.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.parkingEnd.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.cost.toString(),
                              style: const TextStyle(color: Colors.white))),
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
