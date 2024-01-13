import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';
import 'dart:developer';

class ParkingBoard extends StatefulWidget {
  const ParkingBoard({super.key});
  static int rows = 6;
  static int cols = 6;
  static int floors = 3;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _changeFloor(1),
              child: Text('Floor 1'),
            ),
            ElevatedButton(
              onPressed: () => _changeFloor(2),
              child: Text('Floor 2'),
            ),
            ElevatedButton(
              onPressed: () => _changeFloor(3),
              child: Text('floor 3'),
            ),
          ],
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
