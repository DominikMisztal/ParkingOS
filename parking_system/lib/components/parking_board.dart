import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';
import 'dart:developer';

class ParkingBoard extends StatefulWidget {
  const ParkingBoard({super.key});
  static int rows = 8;
  static int cols = 8;
  static int floors = 3;
  static int currentlySelected = -1;
  static final updateNotifier = ValueNotifier(0);
  static List<bool> spotsBusy = [];

  @override
  State<ParkingBoard> createState() => _ParkingBoardState();
}

class _ParkingBoardState extends State<ParkingBoard> {
  int _currentFloor = 1;
  late List<FloorButtonModel> floorButtons;

  void _changeFloor(int newFloor) {
    setState(() {
      floorButtons[_currentFloor - 1].isSelected = false;
      _currentFloor = newFloor;
      floorButtons[_currentFloor - 1].isSelected = true;
    });
  }

  void generateFloorButtons() {
    floorButtons = List.generate(
      ParkingBoard.floors,
      (index) => FloorButtonModel(index + 1),
    );
    floorButtons[_currentFloor - 1].isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    generateFloorButtons();
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
                  final floorButton = floorButtons[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _changeFloor(floorButton.floorNumber),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            floorButton.isSelected ? Colors.green : Colors.blue,
                      ),
                      child: Text('Floor ${floorButton.floorNumber}'),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: ParkingBoard.rows * ParkingBoard.cols,
            // physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ParkingBoard.cols, childAspectRatio: 2),
            itemBuilder: (context, index) => Material(
              child: GestureDetector(
                  child: ParkingTile(
                      id: (index +
                          ((_currentFloor - 1) *
                              (ParkingBoard.cols * ParkingBoard.rows)))),
                  onTap: () => log('tapped')),
            ),
          ),
        ),
      ],
    );
  }
}

class FloorButtonModel {
  final int floorNumber;
  bool isSelected;

  FloorButtonModel(this.floorNumber, {this.isSelected = false});
}
