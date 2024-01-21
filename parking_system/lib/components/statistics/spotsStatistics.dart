import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/models/statistics/spotRecotd.dart';

class SpotsStatisticsWidget extends StatefulWidget {
  const SpotsStatisticsWidget({super.key, required this.selectedParking});

  final String selectedParking;
  @override
  State<SpotsStatisticsWidget> createState() =>
      _SpotsStatisticsWidgetState(selectedParking: this.selectedParking);
}

class _SpotsStatisticsWidgetState extends State<SpotsStatisticsWidget> {
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

  _SpotsStatisticsWidgetState({required this.selectedParking});
  var filterController = TextEditingController();

  void getSpotRecords() {
    spotRecords.add(SpotRecord(
        spotId: '123',
        parkingName: 'Parking 1',
        isTaken: true,
        totalIncome: 561,
        dailyIncome: 64,
        temporaryIncome: 12,
        parkedCarRegistration: 'kl-12345',
        parkingStart: DateTime.now()));
    spotRecords.add(SpotRecord(
      spotId: '124',
      parkingName: 'Parking 1',
      isTaken: false,
      totalIncome: 561,
      dailyIncome: 64,
    ));
    spotRecords.add(SpotRecord(
      spotId: '24',
      parkingName: 'Parking 1',
      isTaken: false,
      totalIncome: 561,
      dailyIncome: 64,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    getSpotRecords();
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
          DataColumn(
              label:
                  Text(columnNames[7], style: TextStyle(color: Colors.white))),
        ],
        rows: spotRecords.map((SpotRecord record) {
          return DataRow(cells: [
            DataCell(Text(record.parkingName,
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.spotId.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.totalIncome.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.dailyIncome.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(record.isTaken.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.parkedCarRegistration == null
                    ? 'N/A'
                    : record.parkedCarRegistration.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.temporaryIncome == null
                    ? 'N/A'
                    : record.temporaryIncome.toString(),
                style: TextStyle(color: Colors.white))),
            DataCell(Text(
                record.parkingStart == null
                    ? 'N/A'
                    : record.parkingStart.toString(),
                style: TextStyle(color: Colors.white)))
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
