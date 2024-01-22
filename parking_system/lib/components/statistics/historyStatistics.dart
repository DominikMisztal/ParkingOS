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

  void getHistoryRecords() async {

    List<ParkingHistoryRecord>? temp = await parkHistory.getParkingHistoryData();
    if(temp != null){
      historyRecords = temp;
      return;
    }
    historyRecords.add(ParkingHistoryRecord(
        vehicleRegistration: 'kl-12345',
        vehicleBrand: 'Mazda',
        parkingName: 'Parking 1',
        spotId: '123',
        parkingStart: DateTime.now(),
        parkingEnd: DateTime.now(),
        cost: 125.25));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getHistoryRecords();
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
        rows: historyRecords.map((ParkingHistoryRecord record) {
          return DataRow(cells: [
            DataCell(Text(record.parkingName,
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.spotId.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.vehicleRegistration.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.vehicleBrand.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.parkingStart.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.parkingEnd.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.cost.toString(),
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
