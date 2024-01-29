import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parking_system/components/custom_formatted_text.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/components/parking_board_live_view.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/models/parkingDB.dart';

import 'parking_statistics.dart';
import 'dart:developer' as developer;

class ParkingLiveView extends StatefulWidget {
  const ParkingLiveView({super.key});
  static String parkingName = "Parking 1";
  static int parkingRows = 20;
  static int parkingCols = 8;
  static int parkingFloors = 3;
  static List<bool> spotsTaken = [];
  @override
  State<ParkingLiveView> createState() => _ParkingLiveViewState();
}

class _ParkingLiveViewState extends State<ParkingLiveView> {
  ParkingServices parkingServices = ParkingServices();
  List<String> parkingNames = ['Parking 1', 'Parking 2'];
  int currentlySelectedSpot = -1;
  late String selectedParking = "Parking 2";
  List<ParkingDb> parkings = [];
  int choosenPark = 0;

  void loadParking() async {
    //connect to DB
    List<String>? tempParking = await parkingServices.getParkingNames();
    if(tempParking == null) return;
    parkingNames.addAll(tempParking);
    List<ParkingDb>? tempParkings = await parkingServices.getParkings();
    if(tempParkings == null) return;
    parkings = tempParkings;
  
  }

  void setValueForParking(int pos){
    choosenPark = pos;
    parkingRows = parkings[pos].height; 
    parkingCols = parkings[pos].width; 
    parkingFloors = parkings[pos].level + 1;
    setSpots(pos);
  }

  void setSpots(int pos){

    List<bool> testPlacements = [];
    for (int i = 0; i < parkingRows * parkingCols * (parkingFloors); i++) {
          
      testPlacements.add(parkings[pos].spots[i].registrationNumber == "" ? false : true);
    }
    ParkingLiveView.spotsTaken = testPlacements;
  }

  @override
  void initState() {
    super.initState();
    loadParking();
  }
  int parkingRows = 3, parkingCols = 4, parkingFloors = 2; 
  @override
  Widget build(BuildContext context) {
    TappedTile tappedt = TappedTile();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ParkingBoardLiveView.cols = parkingCols;
    ParkingBoardLiveView.rows = parkingRows;
    ParkingBoardLiveView.floors = parkingFloors;
    if (ParkingLiveView.spotsTaken.isEmpty) {
      generateTestPlacements();
    }
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Parking Live View'),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: [
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
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
                                  ElevatedButton(
                                    onPressed: () => {Navigator.pop(context)},
                                    child: Text(
                                      'Go back',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: selectedParking,
                                    style: TextStyle(color: Colors.white),
                                    onChanged: (String? newValue) {
                                      int selectedIndex = parkingNames.indexOf(newValue!);
                                      setValueForParking(selectedIndex);
                                      setState(() {
                                        selectedParking = newValue!;
                                      });
                                    },
                                    items: parkingNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: ListenableBuilder(
                                        listenable: tappedt,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          this.currentlySelectedSpot =
                                              tappedt.selectedId;
                                          return Text(
                                            "Currently selected: ${tappedt.selectedId}",
                                            style: const TextStyle(
                                                color: Colors.white60),
                                          );
                                        },
                                      )),
                                  CustomFormattedText(text: spotStateDetails),
                                  CustomFormattedText(
                                      text: "Parking since: 8:00"),
                                  CustomFormattedText(
                                      text: "Currently required to pay: 50 zł"),
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
                tappedTile: tappedt,
              ),
            )
          ])
        ]));
  }

  void goToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParkingStatistics(
              category: 'Parking Spots',
              parkingName: parkings[choosenPark].name,
              spotId: currentlySelectedSpot.toString(),
              vehicleReg: parkings[choosenPark].spots[currentlySelectedSpot].registrationNumber)),
    );
  }

  void changeSelectedSpot(int newSelectedSpot) {
    setState(() {
      currentlySelectedSpot = newSelectedSpot;
      developer.log('Live view selected spot: ${currentlySelectedSpot}');
    });
  }

  void generateTestPlacements() {
    List<bool> testPlacements = [];
    var rand = Random();
    for (int i = 0;
        i <
            ParkingBoardLiveView.cols *
                ParkingLiveView.parkingRows *
                ParkingBoardLiveView.floors;
        i++) {
      testPlacements.add(rand.nextBool());
    }
    ParkingLiveView.spotsTaken = testPlacements;
  }
}
