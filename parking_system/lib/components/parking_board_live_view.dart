import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';
import 'dart:developer';

import 'package:parking_system/components/parking_board_tile_live_view.dart';

class ParkingBoardLiveView extends StatefulWidget {
  const ParkingBoardLiveView({super.key, required this.changeSelectedSpot});
  static int rows = 8;
  static int cols = 8;
  static int floors = 3;
  static int currentlySelected = -1;
  static final updateNotifier = ValueNotifier(0);
  static List<bool> spotsBusy = [];
  final ValueChanged<int> changeSelectedSpot;
  @override
  State<ParkingBoardLiveView> createState() =>
      _ParkingBoardLiveViewState(changeSelectedSpot);
}

class _ParkingBoardLiveViewState extends State<ParkingBoardLiveView> {
  int _currentFloor = 1;
  final ValueChanged<int> changeSelectedSpot;

  _ParkingBoardLiveViewState(this.changeSelectedSpot);

  void _changeFloor(int newFloor) {
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
                  itemCount: ParkingBoardLiveView.floors,
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
            itemCount: ParkingBoardLiveView.rows * ParkingBoardLiveView.cols,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ParkingBoardLiveView.cols, childAspectRatio: 2),
            itemBuilder: (context, index) => Material(
                child: ParkingTileLiveView(
              id: (index +
                  ((_currentFloor - 1) *
                      (ParkingBoardLiveView.cols * ParkingBoardLiveView.rows))),
              changeSelectedSpot: this.changeSelectedSpot,
            )),
          ),
        ),
      ],
    );
  }
}
