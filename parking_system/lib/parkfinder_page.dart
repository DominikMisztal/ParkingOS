import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';

import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/spot.dart';
import 'package:parking_system/services/park_services.dart';

import 'package:parking_system/user_payment.dart';

class Parkfinder extends StatefulWidget {
  const Parkfinder({super.key});

  @override
  State<Parkfinder> createState() => _ParkfinderState();
}

class _ParkfinderState extends State<Parkfinder> {
  ParkingServices parkingServices = ParkingServices();
  void _navigateToPayment(Parking parking, Spot spot) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPaymentScreen(
                parking: parking,
                spot: spot,
              )),
    );
  }

  late Parking currentParking;
  List<Spot> filteredSpaces = [];
  List<ParkingDb> parkingsDb = [];
  @override
  void initState(){
    filteredSpaces = [];
    super.initState();
    addParkings();
  }

  void addParkings() async{
      List<ParkingDb>? tempParkingsDb = await parkingServices.getParkings();
      if(tempParkingsDb != null){
        parkingsDb = tempParkingsDb;
      }

      for (var parking in parkingsDb) {
        //todo: add tarifs
        parkings.add(Parking(parking.address, parking.name, parking.address, parking.level, parking.height * parking.width, 1));
        for (var spot in parking.spots) {
          spots.add(Spot(parking.address, spot.level, spot.idNumber, spot.registrationNumber == "" ? false : true));
        }
      }
  }

  List<Parking> parkings = [
    Parking('1', 'GreatParking', 'Boat 53-590', 2, 10, 100),
    Parking('2', 'FineParking', 'Zgierz 53-590', 2, 10, 0)
  ];
  List<Spot> spots = [
    Spot('1', 1, 1, false),
    Spot('1', 1, 2, true),
    Spot('1', 1, 3, false),
    Spot('1', 1, 4, false),
    Spot('1', 2, 1, false),
    Spot('1', 2, 2, true),
    Spot('1', 2, 3, true),
    Spot('1', 2, 4, false),
    Spot('2', 2, 1, false),
    Spot('2', 2, 2, true),
    Spot('2', 2, 3, true),
    Spot('2', 2, 4, false),
  ];

  void filterSpaces(Parking parking) {
    List<Spot> searchResult = spots
        .where((spot) => !spot.isTaken && spot.parkingId == parking.parkingId)
        .toList();

    setState(() {
      filteredSpaces = searchResult;
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final parkingTimeController = TextEditingController();

    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        color: Colors.white,
      ),
      Container(
        width: width * 3 / 5,
        color: Colors.black87,
      ),
      Container(
        width: width / 3,
        child: Column(
          children: [
            const Text(
              'How many hours do you plan to stay?',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            MyCustomTextField(
                controller: parkingTimeController,
                labelText: 'Enter time',
                obscureText: false),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Search for your Parking',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            const SizedBox(
              height: 64,
            ),
            SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(parkings.length, (int index) {
                final Parking item = parkings[index];
                return ListTile(
                  title: Text(item.name),
                  onTap: () {
                    setState(() {
                      currentParking = item;
                      filterSpaces(item);
                      controller.closeView(item.name);
                    });
                  },
                );
              });
            }),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSpaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    textColor: Colors.white60,
                    title: Text(
                        'Floor: ${filteredSpaces[index].floor} Place_num: ${filteredSpaces[index].number} Price: ${currentParking.price} '),
                    subtitle: Text(
                        filteredSpaces[index].isTaken ? 'Occupied' : 'Free'),
                    onTap: () {
                      //Navigate to payment
                      _navigateToPayment(currentParking, filteredSpaces[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
