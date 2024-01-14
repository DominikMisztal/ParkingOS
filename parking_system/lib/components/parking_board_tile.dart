import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board.dart';

class ParkingTile extends StatelessWidget {
  final int id;
  const ParkingTile({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Color spotColor;
    if (ParkingBoard.spotsBusy.isEmpty) {
      spotColor = Colors.green;
    } else {
      spotColor = ParkingBoard.spotsBusy[id] ? Colors.red : Colors.green;
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
          decoration: BoxDecoration(
            color: spotColor,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(child: Text("ID:" + id.toString()))),
    );
  }
}
