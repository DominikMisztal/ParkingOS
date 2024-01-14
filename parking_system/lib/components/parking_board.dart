import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';
import 'dart:developer';

import 'package:parking_system/parking_maker.dart';

class ParkingBoard extends StatefulWidget {
  const ParkingBoard({super.key});
  static int rows = 8;
  static int cols = 8;
  static int floors = 3;
  static int currentlySelected = -1;
  @override
  State<ParkingBoard> createState() => _ParkingBoardState();
}

class _ParkingBoardState extends State<ParkingBoard> {
  int _currentFloor = 1;

  void _changeFloor(int newFloor) {
    log('Changing to floor $newFloor');
    setState(() {
      _currentFloor = newFloor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ParkingBoard.floors,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _changeFloor(index + 1),
                        child: Text('Floor ${index + 1}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: ParkingBoard.rows * ParkingBoard.cols,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ParkingBoard.cols, childAspectRatio: 2),
            itemBuilder: (context, index) =>
                ParkingTile(id: (index + _currentFloor)),
          ),
        ),
      ],
    );
  }
}
