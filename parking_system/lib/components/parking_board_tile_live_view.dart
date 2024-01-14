import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board.dart';
import 'dart:developer';

import 'package:parking_system/components/parking_board_live_view.dart';

class ParkingTileLiveView extends StatelessWidget {
  final int id;
  final ValueChanged<int> changeSelectedSpot;
  const ParkingTileLiveView(
      {super.key, required this.id, required this.changeSelectedSpot});

  @override
  Widget build(BuildContext context) {
    Color spotColor;
    if (ParkingBoardLiveView.spotsBusy.isEmpty) {
      spotColor = Colors.green;
    } else {
      spotColor =
          ParkingBoardLiveView.spotsBusy[id] ? Colors.red : Colors.green;
    }
    return AbsorbPointer(
        child: GestureDetector(
      onTap: functionOnTap,
      //onTap: () {
      //ParkingBoard.currentlySelected = id;
      //
      //changeSelectedSpot(id);
      //},
      child: Container(
          decoration: BoxDecoration(
            color: spotColor,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(child: Text("ID:" + id.toString()))),
    ));
  }

  void functionOnTap() {
    log('calling change selected spot with id $id');
  }
}
