import 'package:flutter/material.dart';
import 'package:parking_system/utils/Utils.dart';

class TarrifStiffDataTable extends StatefulWidget {
  final Function(Map<String, List<double>>) onValueChanged;
  final Map<String, List<double>> tariffsMap;
  TarrifStiffDataTable(
      {required this.onValueChanged, required this.tariffsMap});
  @override
  _TarrifDataTableState createState() => _TarrifDataTableState(
      onValueChanged: this.onValueChanged, tariffsMap: this.tariffsMap);
}

class _TarrifDataTableState extends State<TarrifStiffDataTable> {
  final Function(Map<String, List<double>>) onValueChanged;
  bool controllersUpdated = false;
  Map<String, List<double>> tariffsMap = {
    '0': [0, 0, 0],
    '12': [0, 0, 0]
  };
  _TarrifDataTableState(
      {required this.onValueChanged, required this.tariffsMap});
  late List<List<TextEditingController>>
      controllersList; //I have no Idea, jak my to będziemy trzymać w bazie

  int columnCount = 3;

  @override
  void initState() {
    super.initState();
    controllersList = List.generate(
      4,
      (rowIndex) => List.generate(
        columnCount,
        (colIndex) => TextEditingController(),
      ),
    );
    for (int i = 0; i < controllersList.length; i++) {
      for (int j = 0; j < controllersList[i].length; j++) {
        controllersList[i][j].addListener(() {
          listener();
        });
      }
    }
  }

  void listener() {
    if (controllersUpdated) {
      updateTariffsMap();
      onValueChanged(tariffsMap);
    }
  }

  void updateTariffsMap() {
    Map<String, List<double>> temp;
    // String tariff1Time = controllersList[0][1].text;
    // String tariff2Time = controllersList[0][2].text;
    // UPDATE TIME SELECTION
    String tariff1Time = '8';
    String tariff2Time = '16';
    double tariff1_1 = double.parse(
        controllersList[0][1].text.isEmpty ? '0' : controllersList[0][1].text);
    double tariff1_2 = double.parse(
        controllersList[1][1].text.isEmpty ? '0' : controllersList[1][1].text);
    double tariff1_3 = double.parse(
        controllersList[2][1].text.isEmpty ? '0' : controllersList[2][1].text);
    double tariff2_1 = double.parse(
        controllersList[0][2].text.isEmpty ? '0' : controllersList[0][2].text);
    double tariff2_2 = double.parse(
        controllersList[1][2].text.isEmpty ? '0' : controllersList[1][2].text);
    double tariff2_3 = double.parse(
        controllersList[2][2].text.isEmpty ? '0' : controllersList[2][2].text);
    temp = {
      tariff1Time: [tariff1_1, tariff1_2, tariff1_3],
      tariff2Time: [tariff2_1, tariff2_2, tariff2_3]
    };
    tariffsMap = temp;
  }

  void updateControllers() {
    String key1 = tariffsMap.keys.elementAt(0);
    String key2 = tariffsMap.keys.elementAt(1);
    List<double>? tariffs1Values = tariffsMap[key1];
    List<double>? tariffs2Values = tariffsMap[key2];
    controllersList[0][1].text = tariffs1Values![0].toString();
    controllersList[1][1].text = tariffs1Values[0].toString();
    controllersList[2][1].text = tariffs1Values[0].toString();
    controllersList[0][2].text = tariffs2Values![0].toString();
    controllersList[1][2].text = tariffs2Values[0].toString();
    controllersList[2][2].text = tariffs2Values[0].toString();
  }

  @override
  Widget build(BuildContext context) {
    updateControllers();
    controllersUpdated = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarrif Editor',
          style: TextStyle(color: Colors.white60),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30.0,
          columns: List.generate(
            columnCount,
            (index) => DataColumn(
              label: index == 0
                  ? const Text('Tariffs',
                      style: TextStyle(color: Colors.white70))
                  : index == 1
                      ? const Text('8:00-16:00',
                          style: TextStyle(color: Colors.white70))
                      : const Text('16:00-8:00',
                          style: TextStyle(color: Colors.white70)),
            ),
          ),
          rows: List.generate(
            3,
            (rowIndex) => DataRow(
              cells: List.generate(
                columnCount,
                (colIndex) {
                  if (colIndex == 0) {
                    return DataCell(
                      Text(
                          rowIndex == 0
                              ? 'Price for the first hour'
                              : rowIndex == 1
                                  ? 'Price for the second hour'
                                  : rowIndex == 2
                                      ? 'Price for every next hour'
                                      : '',
                          style: const TextStyle(color: Colors.white60)),
                    );
                  } else {
                    // For other columns, use TextFormField
                    return DataCell(TextFormField(
                      controller: controllersList[rowIndex][colIndex],
                      decoration: const InputDecoration(
                        hintText: 'Enter price',
                      ),
                    ));
                  }
                },
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       if (columnCount < 3) {
      //         controllersList.forEach((controllers) {
      //           controllers.add(TextEditingController());
      //         });
      //         columnCount++;
      //       } else {
      //         showToast('You can only have up to 2 tarrifs');
      //       }
      //     });
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class TarrifTimePicker extends StatefulWidget {
  const TarrifTimePicker({super.key});

  @override
  State<TarrifTimePicker> createState() => _TarrifTimePickerState();
}

class _TarrifTimePickerState extends State<TarrifTimePicker> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 00);
  final TimeOfDay _time2 = const TimeOfDay(hour: 12, minute: 00);

  void _selectTime(bool start) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: start ? _time : _time2,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        start ? _time = newTime : _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(
        onPressed: () {
          _selectTime(true);
        },
        child: Text(' From: ${_time.format(context)}'),
      ),
      TextButton(
        onPressed: () {
          _selectTime(false);
        },
        child: Text(' To: ${_time2.format(context)}'),
      ),
    ]);
  }
}
