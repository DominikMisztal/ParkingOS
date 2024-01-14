import 'package:flutter/material.dart';
import 'package:parking_system/components/carCard.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/components/parking_board_live_view.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';

class ParkingLiveView extends StatefulWidget {
  const ParkingLiveView({super.key});
  static String parkingName = "Parking 1";
  static int parkingRows = 2;
  static int parkingCols = 2;
  static int parkingFloors = 3;
  static List<bool> spotsTaken = [
    true,
    false,
    false,
    true,
    true,
    false,
    false,
    true,
    true,
    false,
    false,
    true,
  ];
  @override
  State<ParkingLiveView> createState() => _ParkingLiveViewState();
}

class _ParkingLiveViewState extends State<ParkingLiveView> {
  int currentlySelectedSpot = -1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ParkingBoardLiveView.cols = ParkingLiveView.parkingCols;
    ParkingBoardLiveView.rows = ParkingLiveView.parkingRows;
    ParkingBoardLiveView.floors = ParkingLiveView.parkingFloors;
    ParkingBoardLiveView.spotsBusy = ParkingLiveView.spotsTaken;
    String spotStateDetails;
    if (currentlySelectedSpot == -1) {
      spotStateDetails = "No spot selected";
    } else {
      if (ParkingBoard.spotsBusy[currentlySelectedSpot]) {
        spotStateDetails = "Spot is taken by: KL-12345";
      } else {
        spotStateDetails = "Spot is empty";
      }
    }

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
                                child: Text(ParkingLiveView.parkingName),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Text(
                                    "Currently selected: ${currentlySelectedSpot}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Text(spotStateDetails),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Text("Parking since: 8:00"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: Text("Currently required to pay: 50 zł"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: goToStatistics,
                                  child: const Text('Spot statistics'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
        Container(
          width: (2 * width / 3),
          child: ParkingBoardLiveView(
            changeSelectedSpot: changeSelectedSpot,
          ),
        )
      ])
    ]);
  }

  void goToStatistics() {}

  void changeSelectedSpot(int newSelectedSpot) {
    setState(() {
      currentlySelectedSpot = newSelectedSpot;
    });
  }
}
