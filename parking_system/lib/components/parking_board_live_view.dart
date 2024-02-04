import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board_tile.dart';
import 'dart:developer';

import 'package:parking_system/components/parking_board_tile_live_view.dart';

class ParkingBoardLiveView extends StatefulWidget {
  const ParkingBoardLiveView(
      {super.key, required this.changeSelectedSpot, required this.tappedTile});
  static int rows = 8;
  static int cols = 8;
  static int floors = 3;
  static int currentlySelected = -1;
  static final updateNotifier = ValueNotifier(0);
  static List<bool> spotsBusy = [];
  final ValueChanged<int> changeSelectedSpot;
  final TappedTile tappedTile;
  @override
  State<ParkingBoardLiveView> createState() =>
      _ParkingBoardLiveViewState(changeSelectedSpot);
}

class _ParkingBoardLiveViewState extends State<ParkingBoardLiveView> {
  int _currentFloor = 1;
  final ValueChanged<int> changeSelectedSpot;
  late List<FloorButtonModel> floorButtons;

  void generateFloorButtons() {
    floorButtons = List.generate(
      ParkingBoardLiveView.floors,
      (index) => FloorButtonModel(index + 1),
    );
    floorButtons[_currentFloor - 1].isSelected = true;
  }

  _ParkingBoardLiveViewState(this.changeSelectedSpot);

  void _changeFloor(int newFloor) {
    setState(() {
      floorButtons[_currentFloor - 1].isSelected = false;
      _currentFloor = newFloor;
      floorButtons[_currentFloor - 1].isSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //TappedTile tappedt = TappedTile();
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
                itemCount: ParkingBoardLiveView.floors,
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
            itemCount: ParkingBoardLiveView.rows * ParkingBoardLiveView.cols,
            //physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ParkingBoardLiveView.cols, childAspectRatio: 2),
            itemBuilder: (context, index) => Material(
                child: ParkingTileLiveView(
              id: (index +
                  ((_currentFloor - 1) *
                      (ParkingBoardLiveView.cols * ParkingBoardLiveView.rows))),
              changeSelectedSpot: this.changeSelectedSpot,
              tappedTile: widget.tappedTile,
            )),
          ),
        ),
      ],
    );
  }
}

class TappedTile extends ChangeNotifier {
  int selectedId = -1;
  void setId(int newId) {
    if (newId == this.selectedId) {
      selectedId = -1; // unTap
    } else {
      this.selectedId = newId;
    }
    notifyListeners();
  }
}

class FloorButtonModel {
  final int floorNumber;
  bool isSelected;

  FloorButtonModel(this.floorNumber, {this.isSelected = false});
}
