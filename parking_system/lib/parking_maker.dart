import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/components/parking_board.dart';

import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/components/tarrifs_stiff.dart';
import 'package:parking_system/models/car_model.dart';

import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/spot.dart';
import 'package:parking_system/Utils/Utils.dart';
import 'package:parking_system/services/park_services.dart';

class ParkingMaker extends StatefulWidget {
  const ParkingMaker({super.key});

  @override
  State<ParkingMaker> createState() => _ParkingMakerState();
}

class _ParkingMakerState extends State<ParkingMaker> {
  final ParkingServices _parkingServices = ParkingServices();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final widthController = TextEditingController(text: "8");
  final heightController = TextEditingController(text: "8");
  final floorsController = TextEditingController(text: "3");
  List<String> parkingNames = ['Parking 1', 'Parking 2'];
  late String selectedParking;
  int selectedParkingIndex = 0;

  Map<String, List<double>> tariffsMap = {
    '0': [0, 0, 0],
    '12': [0, 0, 0]
  };
  List<ParkingDb> _parkings = [];
  int parkingCols = 8;
  int parkingRows = 8;
  int parkingFloors = 3;
  bool _toggleTariffParking = false;
  bool shouldRenewData = false;
  void getParkingNames() {
    //TO DO GET PARKING NAMES
    selectedParking = parkingNames[selectedParkingIndex];

    if(_parkings.isNotEmpty && shouldRenewData){
      nameController.text = _parkings[selectedParkingIndex].name;
      addressController.text = _parkings[selectedParkingIndex].address;
      widthController.text = _parkings[selectedParkingIndex].width.toString();
      heightController.text = _parkings[selectedParkingIndex].height.toString();
      floorsController.text = _parkings[selectedParkingIndex].height.toString();
      setState(() {
      for (var element in _parkings) {
        tariffsMap = _parkings[selectedParkingIndex].tarifs;
     }
    });
      print(tariffsMap);
    }
    shouldRenewData = true;
  }
  void getParkings() async{
    _parkings = (await _parkingServices.getParkings())!;

    parkingNames.clear();

     setState(() {
      for (var element in _parkings) {
        parkingNames.add(element.name);
     }
    });
    shouldRenewData = false;
  }

   @override
  void initState() {
    super.initState();
    getParkings();
  }


  void updateParkingData() {
    nameController.text = '';
    addressController.text = '';
    widthController.text = '8';
    heightController.text = '8';
    floorsController.text = '0';
  }

  void _addParking() {
    int width = int.parse(widthController.text);
    int height = int.parse(heightController.text);
    int level = int.parse(floorsController.text);
    String name = nameController.text;
    String address = addressController.text;
    if (width <= 0 ||
        height <= 0 ||
        level <= 0 ||
        name == "" ||
        address == "") {
      showToast("User details not found");
      return;
    }
    List<SpotDb> spots = [];
    int amountOfSpots = width * height * level;
    for (int i = 0; i < amountOfSpots; i++) {
      level = (i / (width * height)).toInt();
      SpotDb spot =
          SpotDb(registrationNumber: "", date: "", idNumber: i, level: level);
      spots.add(spot);
    }
    Map<String, List<double>> tarifs = setTariff();

    ParkingDb parking = ParkingDb(
      tarifs: tarifs,
      height: height,
      width: width,
      level: level,
      address: address,
      name: name,
      spots: spots,
      income: 0,
      dailyIncome: 0,
    );
    _parkingServices.addParking(parking);
  }

  //todo: set from this dummie values to actual ones, '12', '0', [1,2,3], [2,4,6]
  Map<String, List<double>> setTariff() {
    return tariffsMap;
  }

  late BuildContext tempContext;

  @override
  Widget build(BuildContext context) {
    tempContext = context;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    getParkingNames();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Parking Maker'),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: [
          Container(
            height: height - 30,
            width: width - 30,
            color: Colors.white60,
          ),
          Row(children: [
            Material(
                child: Container(
                    width: width / 3,
                    child: Form(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              color: Colors.black87,
                              width: (width / 3) * 2,
                              child: ListView(
                                clipBehavior: Clip.none,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () => {Navigator.pop(context)},
                                      style: ElevatedButton.styleFrom(),
                                      child: const Text(
                                        'Go back',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(10)),
                                  DropdownButton<String>(
                                    value: selectedParking,
                                    style: TextStyle(color: Colors.white),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedParkingIndex =
                                            parkingNames.indexOf(newValue!);
                                        selectedParking = newValue!;
                                        updateParkingData();
                                      });
                                    },
                                    items: parkingNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  MyCustomTextField(
                                      controller: nameController,
                                      labelText: 'Name',
                                      hintText: 'Enter parking name',
                                      obscureText: false),
                                  MyCustomTextField(
                                      controller: addressController,
                                      labelText: 'Adress',
                                      hintText: 'Enter parking address',
                                      obscureText: false),
                                  MyCustomTextField(
                                      controller: widthController,
                                      labelText: 'Spot per row',
                                      hintText: 'Enter spot per row number',
                                      obscureText: false),
                                  MyCustomTextField(
                                      controller: heightController,
                                      labelText: 'Spot per column',
                                      hintText: 'Enter spot per column number',
                                      obscureText: false),
                                  MyCustomTextField(
                                      controller: floorsController,
                                      labelText: 'Number of floors',
                                      hintText: 'Enter number of floors',
                                      obscureText: false),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16.0),
                                    child: ElevatedButton(
                                      onPressed: generateParking,
                                      child: const Text('Generate'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16.0),
                                    child: ElevatedButton(
                                      onPressed: switchParkingNTarrifs,
                                      child: const Text('Parking / Tarrifs'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16.0),
                                    child: ElevatedButton(
                                      onPressed: saveParking,
                                      child: const Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
            Container(
              width: (2 * width / 3),
              child: _toggleTariffParking
                  ? TarrifStiffDataTable(
                      onValueChanged: updateTariffValues,
                      tariffsMap: this.tariffsMap,
                    )
                  : ParkingBoard(),
            )
          ])
        ]));
  }

  void updateTariffValues(Map<String, List<double>> tariffsUpdatedMap) {
    tariffsMap = tariffsUpdatedMap;
  }

  void saveParking() {
    if (validateParking()) {
      _addParking();
    }
  }

  void generateParking() {
    if (validateParking()) {
      setState(() {
        parkingCols = int.parse(widthController.text);
        parkingRows = int.parse(heightController.text);
        parkingFloors = int.parse(floorsController.text);

        ParkingBoard.cols = parkingCols;
        ParkingBoard.rows = parkingRows;
        ParkingBoard.floors = parkingFloors;
      });
    }
  }

  bool validateParking() {
    int parkCols = int.parse(widthController.text);
    int parkRows = int.parse(heightController.text);
    int parkFloors = int.parse(floorsController.text);
    if (parkFloors < 1 || parkFloors > 8) {
      showAlertDialog(tempContext, 'Wrong amount of floors!');
      return false;
    } else if (parkCols < 1 || parkCols > 20) {
      showAlertDialog(tempContext, 'Wrong amount of spots per row!');
      return false;
    } else if (parkRows < 1 || parkRows > 20) {
      showAlertDialog(tempContext, 'Wrong amount of spots per collumn!');
      return false;
    }

    return true;
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning",
        style: TextStyle(color: Colors.white),
      ),
      content: Text(message, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void switchParkingNTarrifs() {
    setState(() {
      _toggleTariffParking = !_toggleTariffParking;
    });
  }
}
