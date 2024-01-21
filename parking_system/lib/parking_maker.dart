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
  int parkingCols = 8;
  int parkingRows = 8;
  int parkingFloors = 3;
  bool _toggleTariffParking = false;
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
      SpotDb spot = SpotDb(registrationNumber: "", date: "");
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
        spots: spots);
    _parkingServices.addParking(parking);
  }

  //todo: set from this dummie values to actual ones, '12', '0', [1,2,3], [2,4,6]
  Map<String, List<double>> setTariff() {
    Map<String, List<double>> tarifs = {};
    List<double> tarif1 = [1, 2, 3];
    List<double> tarif2 = [2, 4, 6];
    tarifs['12'] = (tarif1);
    tarifs['0'] = (tarif2);
    return tarifs;
  }

  late BuildContext tempContext;

  @override
  Widget build(BuildContext context) {
    tempContext = context;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => {Navigator.pop(context)},
                                    child: Text(
                                      'Go back',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
              child: _toggleTariffParking ? TarrifStiffDataTable() : ParkingBoard(),
            )
          ])
        ]));
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
