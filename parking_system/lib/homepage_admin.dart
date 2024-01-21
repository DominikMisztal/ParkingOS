import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/parking_expenses.dart';
import 'package:parking_system/parking_maker.dart';
import 'package:parking_system/parking_live_view.dart';
import 'package:parking_system/parking_statistics.dart';
import 'package:parking_system/parking_summary.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page Admin'),
        ),
        body: Column(
          children: [
            Text(email),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingMaker()),
                  );
                },
                child: const Text("Parking Maker"),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingLiveView()),
                  );
                },
                child: const Text("Parking Live View"),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParkingStatistics(
                            category: 'Parkings',
                            parkingName: 'Parking 1',
                            spotId: '1',
                            vehicleReg: 'kl-12345')),
                  );
                },
                child: const Text("Parking Statistics"),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingExpenses()),
                  );
                },
                child: const Text("Parking Expenses"),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingSummary()),
                  );
                },
                child: const Text("Parking Summary"),
              ),
            ),
          ],
        ));
  }
}
