import 'package:flutter/material.dart';
import 'package:parking_system/components/carCard.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';

class ParkingMaker extends StatefulWidget {
  const ParkingMaker({super.key});

  @override
  State<ParkingMaker> createState() => _ParkingMakerState();
}

class _ParkingMakerState extends State<ParkingMaker> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final widthController = TextEditingController(text: "8");
  final heightController = TextEditingController(text: "8");
  final floorsController = TextEditingController(text: "3");
  int parkingCols = 8;
  int parkingRows = 8;
  int parkingFloors = 1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter parking name',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    hintText: 'Enter parking address',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: widthController,
                                  decoration: InputDecoration(
                                    labelText: 'Width',
                                    hintText: 'Enter width',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: heightController,
                                  decoration: InputDecoration(
                                    labelText: 'Height',
                                    hintText: 'Enter height',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: floorsController,
                                  decoration: InputDecoration(
                                    labelText: 'Number of floors',
                                    hintText: 'Enter number of floors',
                                  ),
                                ),
                              ),
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
          child: ParkingBoard(),
        )
      ])
    ]);
  }

  void saveParking() {}

  void generateParking() {
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
