import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/parkingRecord.dart';

class ParkingStatisticsWidget extends StatefulWidget {
  const ParkingStatisticsWidget({super.key, required this.selectedParking});

  final String selectedParking;
  @override
  State<ParkingStatisticsWidget> createState() =>
      _ParkingStatisticsWidgetState(selectedParking: this.selectedParking);
}

class _ParkingStatisticsWidgetState extends State<ParkingStatisticsWidget> {
  String selectedParking;
  List<String> parkingNames = [];
  List<ParkingRecord> parkingRecords = [];
  List<String> columnNames = [
    'Parking Name',
    'Amount of Spots',
    'Taken Spots',
    'Total Income',
    'Today\'s Income'
  ];
  List<String> orderingTypes = ['Asc', 'Desc'];
  String selectedOrdering = 'Asc';
  String selectedColumn = 'Parking Name';
  String selectedColumnForFiltering = 'Parking Name';

  _ParkingStatisticsWidgetState({required this.selectedParking});
  var filterController = TextEditingController();

  void getParkingRecords() {
    parkingRecords.add(ParkingRecord(
      parkingName: 'Parking 1',
      amountOfSpots: 100,
      takenSpots: 50,
      totalIncome: 500.0,
      todayIncome: 50.0,
    ));
    parkingRecords.add(ParkingRecord(
      parkingName: 'Parking 2',
      amountOfSpots: 200,
      takenSpots: 100,
      totalIncome: 1000.0,
      todayIncome: 100.0,
    ));
    parkingRecords.add(ParkingRecord(
      parkingName: 'Parking 3',
      amountOfSpots: 300,
      takenSpots: 150,
      totalIncome: 1500.0,
      todayIncome: 150.0,
    ));
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
            'Parking Name',
            style: TextStyle(color: Colors.white),
          )),
          DataColumn(
              label: Text('Amount of Spots',
                  style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text('Taken Spots', style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text('Total Income', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Today\'s Income',
                  style: TextStyle(color: Colors.white))),
        ],
        rows: parkingRecords.map((ParkingRecord record) {
          return DataRow(cells: [
            DataCell(Text(record.parkingName,
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.amountOfSpots.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.takenSpots.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.totalIncome.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.todayIncome.toString(),
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
