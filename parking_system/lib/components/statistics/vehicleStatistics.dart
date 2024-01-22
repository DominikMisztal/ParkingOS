import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/vehicleRecord.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/models/car_model.dart';

class VehicleStatisticsWidget extends StatefulWidget {
  const VehicleStatisticsWidget({super.key, required this.selectedParking});

  final String selectedParking;
  @override
  State<VehicleStatisticsWidget> createState() =>
      _VehicleStatisticsWidgetState(selectedParking: this.selectedParking);
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
    'Is Parked',
    'Total Payments',
    'Model',
    'Spot ID',
    'Parking Since'
  ];
  List<String> orderingTypes = ['Asc', 'Desc'];
  String selectedOrdering = 'Asc';
  String selectedColumn = 'Vehicle Registration';
  String selectedColumnForFiltering = 'Vehicle Registration';

  _VehicleStatisticsWidgetState({required this.selectedParking});
  var filterController = TextEditingController();

  void getParkingRecords() async {
    List<String>? carRegistrations = await parkHistory.getAllRegistrations();
    if(carRegistrations == null) return;
    Set<String> uniqueSet = Set<String>.from(carRegistrations);
    carRegistrations = uniqueSet.toList();
    print(carRegistrations);
    
    for (var registration in carRegistrations) {
      Car? car = await userService.getCarByRegistration(registration);
      if(car == null) continue;
        vehicleRecords.add(VehicleRecord(
        vehicleRegistration: car.registration_num,
        vehicleBrand: car.brand,
        isParked: false,
        totalExpenses: car.expences,
        model: car.model,
        ));
    }

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getParkingRecords();
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
                    final String option = options.elementAt(index);
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
      Row(
        children: [
          Text(
            'Order by: ',
            style: TextStyle(color: Colors.white),
          ),
          Padding(padding: EdgeInsets.all(10)),
          DropdownButton<String>(
            value: selectedColumn,
            style: TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                selectedColumn = newValue!;
              });
            },
            items: columnNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          DropdownButton<String>(
            value: selectedOrdering,
            style: TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                selectedOrdering = newValue!;
              });
            },
            items: orderingTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(
            onPressed: sortTable,
            child: Text(
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
          Text(
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
            style: TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                selectedColumnForFiltering = newValue!;
              });
            },
            items: columnNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(
            onPressed: filterTable,
            child: Text(
              'Filter',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      Padding(padding: EdgeInsets.all(10)),
      DataTable(
        columns: [
          DataColumn(
              label: Text(
            columnNames[0],
            style: TextStyle(color: Colors.white),
          )),
          DataColumn(
              label:
                  Text(columnNames[1], style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text(columnNames[2], style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text(columnNames[3], style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text(columnNames[4], style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text(columnNames[5], style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text(columnNames[6], style: TextStyle(color: Colors.white))),
        ],
        rows: vehicleRecords.map((VehicleRecord record) {
          return DataRow(cells: [
            DataCell(Text(record.vehicleRegistration,
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.vehicleBrand.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.totalExpenses.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.isParked.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.model == null
                    ? 'N/A'
                    : record.model.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.spotId == null ? 'N/A' : record.spotId.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.parkingSince == null
                    ? 'N/A'
                    : record.parkingSince.toString(),
                style: TextStyle(color: Colors.white))),
          ]);
        }).toList(),
      )
    ]);
  }

  void sortTable() {
    //Change to DB connection
  }

  void filterTable() {
    //change to DB connection
  }
}
