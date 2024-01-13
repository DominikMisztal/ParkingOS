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
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final floorsController = TextEditingController();

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

                              // TO CHANGE -------------------------------------------------
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () => floorButton(1),
                                  child: const Text('1'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () => floorButton(2),
                                  child: const Text('2'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () => floorButton(3),
                                  child: const Text('3'),
                                ),
                              ),

                              // TO CHANGE -------------------------------------------------
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

  void floorButton(int floor) {}

  void generateParking() {}
}
