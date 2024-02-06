import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/vehicleRecord.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/models/car_model.dart';

class VehicleStatisticsWidget extends StatefulWidget {
  const VehicleStatisticsWidget(
      {super.key,
      required this.selectedParking,
      required this.selectedVehicle});

  final String selectedParking;
  final String selectedVehicle;
  @override
  State<VehicleStatisticsWidget> createState() => _VehicleStatisticsWidgetState(
      selectedParking: this.selectedParking,
      selectedVehicleForFiltering: this.selectedVehicle);
}

class _VehicleStatisticsWidgetState extends State<VehicleStatisticsWidget> {
  ParkHistory parkHistory = ParkHistory();
  UserService userService = UserService();
  String selectedParking;
  List<String> parkingNames = [];
  List<VehicleRecord> vehicleRecords = [];
  List<String> columnNames = [
    'Vehicle Registration',
    'Vehicle Brand',
    'Total Payments',
    'Is Parked',
    'Model',
    'Spot ID',
    'Parking Since'
  ];
  List<String> orderingTypes = ['Asc', 'Desc'];
  String selectedOrdering = 'Asc';
  String selectedColumn = 'Vehicle Registration';
  String selectedColumnForFiltering = 'Vehicle Registration';
  String selectedVehicleForFiltering = '';

  _VehicleStatisticsWidgetState(
      {required this.selectedParking,
      required this.selectedVehicleForFiltering});
  var filterController = TextEditingController();

  Future<List<String>?> getParkingRecords() async {
    List<String>? carRegistrations = await parkHistory.getAllRegistrations();
    if (carRegistrations == null) return null;
    Set<String> uniqueSet = Set<String>.from(carRegistrations);
    carRegistrations = uniqueSet.toList();
    print(carRegistrations);
    vehicleRecords.clear();
    for (var registration in carRegistrations) {
      Car? car = await userService.getCarByRegistration(registration);
      if (car == null) continue;

      vehicleRecords.add(VehicleRecord(
        vehicleRegistration: car.registration_num,
        vehicleBrand: car.brand,
        isParked: false,
        totalExpenses: car.expences,
        model: car.model,
      ));
    }
    return carRegistrations;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getParkingRecords();
    return FutureBuilder(
      future: getParkingRecords(),
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
                      ],
                      rows: vehicleRecords.map((VehicleRecord record) {
                        return DataRow(cells: [
                          DataCell(Text(record.vehicleRegistration,
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.vehicleBrand.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.totalExpenses.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(record.isParked.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.model == null
                                  ? 'N/A'
                                  : record.model.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.spotId == null
                                  ? 'N/A'
                                  : record.spotId.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              record.parkingSince == null
                                  ? 'N/A'
                                  : record.parkingSince.toString(),
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
