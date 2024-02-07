import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/statistics/vehicleRecord.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/ticket_services.dart';
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
  TicketService ticketService = TicketService();
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
    List<Car?> cars;
    bool ascending = selectedOrdering == "Asc" ? true : false;
    if (filterController.text != "") {
      if (selectedColumnForFiltering == "Vehicle Registration") {
        cars = await userService.getAllCars(
            registration: (filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Vehicle Brand") {
        cars = await userService.getAllCars(
            brand: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Model") {
        cars = await userService.getAllCars(
            model: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      } else {
        cars = await userService.getAllCars(
            sortBy: selectedColumn, asc: ascending);
      }
    } else {
      cars =
          await userService.getAllCars(sortBy: selectedColumn, asc: ascending);
    }

    if (cars == null) return [];
    vehicleRecords.clear();
    for (var car in cars) {
      List<String> values = await checkSpot(car!.registration_num);

      int? spot = int.tryParse(values[0]);
      DateTime? dateTime = DateTime.tryParse(values[1]);
      spot ??= -1;
      vehicleRecords.add(VehicleRecord(
        vehicleRegistration: car!.registration_num,
        vehicleBrand: car.brand,
        totalExpenses: 0,
        model: car.model,
        spotId: spot == -1 ? "" : spot.toString(),
        isParked: spot == -1 ? false : true,
      ));
      if (dateTime != null)
        vehicleRecords[vehicleRecords.length - 1].parkingSince = dateTime;
    }

    vehicleRecords = removeDuplicates(vehicleRecords);
    for (var element in vehicleRecords) {
      double expenses =
          await parkHistory.findCarHistory(element.vehicleRegistration);
      if (expenses != null) element.totalExpenses = expenses;
    }

    if (filterController.text != "") {
      if (selectedColumnForFiltering == "Vehicle Registration") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            vehicleRegistration: (filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Vehicle Brand") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            vehicleBrand: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Total Payments") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            totalExpenses: double.tryParse(filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Is Parked") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            isParked: bool.tryParse(filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Model") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            model: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Spot ID") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            spotId: filterController.text,
            sortBy: selectedColumn,
            asc: ascending);
      } else if (selectedColumnForFiltering == "Parking Since") {
        vehicleRecords = filterVehicleRecords(vehicleRecords,
            parkingSince: DateTime.tryParse(filterController.text),
            sortBy: selectedColumn,
            asc: ascending);
      }
    }

    return [];
  }

  List<VehicleRecord> filterVehicleRecords(List<VehicleRecord> records,
      {String? vehicleRegistration,
      String? vehicleBrand,
      bool? isParked,
      String? model,
      String? spotId,
      DateTime? parkingSince,
      double? totalExpenses,
      String? sortBy,
      bool? asc}) {
    List<VehicleRecord> filteredRecords = [];

    for (var record in records) {
      if (vehicleRegistration != null &&
          record.vehicleRegistration != vehicleRegistration) {
        continue;
      }
      if (vehicleBrand != null && record.vehicleBrand != vehicleBrand) {
        continue;
      }
      if (isParked != null && record.isParked != isParked) {
        continue;
      }
      if (model != null && record.model != model) {
        continue;
      }
      if (spotId != null && record.spotId != spotId) {
        continue;
      }
      if (parkingSince != null && record.parkingSince != parkingSince) {
        continue;
      }
      if (totalExpenses != null && record.totalExpenses != totalExpenses) {
        continue;
      }
      filteredRecords.add(record);
    }

    if (sortBy != null) {
      filteredRecords.sort((a, b) {
        int result = 0;
        switch (sortBy) {
          case 'Vehicle Registration':
            result = a!.vehicleRegistration.compareTo(b!.vehicleRegistration);
            break;
          case 'Vehicle Brand':
            result = a!.vehicleBrand.compareTo(b!.vehicleBrand);
            break;
          case 'Total Payments':
            result = a!.totalExpenses.compareTo(b!.totalExpenses);
            break;
          case 'Spot ID':
            result = (a?.spotId ?? '').compareTo(b?.spotId ?? '');
            break;
          case 'Model':
            result = (a?.model ?? '').compareTo(b?.model ?? '');
            break;
          default:
            break;
        }
        return asc != null && asc == true ? result : -result;
      });
    }

    return filteredRecords;
  }

  List<VehicleRecord> removeDuplicates(List<VehicleRecord> cars) {
    Set<String> seenRegistrations = Set<String>();
    List<VehicleRecord> filteredCars = [];

    for (VehicleRecord car in cars) {
      if (!seenRegistrations.contains(car.vehicleRegistration)) {
        filteredCars.add(car);
        seenRegistrations.add(car.vehicleRegistration);
      }
    }
    return filteredCars;
  }

  Future<List<String>> checkSpot(String regNumber) async {
    String spot = "-1";
    String parkedSince = "";
    Layover? ticket = await ticketService.findCarWithTicket(regNumber);
    if (ticket != null) {
      spot = ticket.spotId;
      parkedSince = ticket.startDate;
    }
    return [spot, parkedSince];
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
    setState(() {});
    //Change to DB connection
  }

  void filterTable() {
    setState(() {});
    //change to DB connection
  }
}
