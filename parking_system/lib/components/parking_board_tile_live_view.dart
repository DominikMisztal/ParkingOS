import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:parking_system/components/parking_board_live_view.dart';

class ParkingTileLiveView extends StatefulWidget {
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  final int id;
  final ValueChanged<int> changeSelectedSpot;
  final TappedTile tappedTile;
  final int currentlySelectedSpot;

  ParkingTileLiveView(
      {super.key,
      required this.id,
      required this.changeSelectedSpot,
      required this.tappedTile,
      required this.currentlySelectedSpot});

  @override
  State<ParkingTileLiveView> createState() =>
      _ParkingTileLiveViewState(changeSelectedSpot: this.changeSelectedSpot);
}

class _ParkingTileLiveViewState extends State<ParkingTileLiveView> {
  final ValueChanged<int> changeSelectedSpot;
  _ParkingTileLiveViewState({required this.changeSelectedSpot});
  int selectedSpot = -1;

  @override
  Widget build(BuildContext context) {
    Color spotColor;
    if (ParkingBoardLiveView.spotsBusy.isEmpty) {
      spotColor = Colors.green;
    } else {
      spotColor =
          ParkingBoardLiveView.spotsBusy[widget.id] ? Colors.red : Colors.green;
    }

    return GestureDetector(
      onTap: () {
        functionOnTap();
        widget._isSelected = !widget._isSelected;
      },
      child: ListenableBuilder(
          listenable: widget.tappedTile,
          builder: (context, child) {
            Color borderColor;
            if (widget.currentlySelectedSpot == widget.id) {
              borderColor = Colors.amber;
            } else {
              borderColor = Colors.black;
            }
            return Container(
                decoration: BoxDecoration(
                  color: spotColor,
                  border: Border.all(
                      color:
                          borderColor, //widget._isSelected ? Colors.amber : Colors.black
                      width: 2),
                ),
                child: Center(child: Text("ID:" + widget.id.toString())));
          }),
    );
  }

  void functionOnTap() {
    log('calling change selected spot with id ${widget.id}');
    log('Previously selected Id: ${widget.tappedTile.selectedId}');

    setState(() {
      widget.tappedTile.setId(widget.id);
      changeSelectedSpot(widget.id);
    });
  }
}
