import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';

class ParkingBoard extends StatefulWidget {
  const ParkingBoard({super.key});
  static int rows = 6;
  static int cols = 6;
  static int floors = 1;
  static int currentFloor = 1;
  @override
  State<ParkingBoard> createState() => _ParkingBoardState();
}

class _ParkingBoardState extends State<ParkingBoard> {
  int _currentFloor = 1;

  void _changeFloor(int newFloor) {
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
              onPressed: () {
                // Handle button press
              },
              child: Text('Button 1'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Button 2'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Button 3'),
            ),
          ],
        ),
        Expanded(
          child: GridView.builder(
            itemCount: ParkingBoard.rows * ParkingBoard.cols,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ParkingBoard.cols, childAspectRatio: 2),
            itemBuilder: (context, index) => ParkingTile(
                id: (index +
                    (ParkingBoard.currentFloor - 1) *
                        ParkingBoard.rows *
                        ParkingBoard.cols)),
          ),
        ),
      ],
    );
  }
}
