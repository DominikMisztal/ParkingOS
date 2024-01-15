import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/parking_board.dart';
import 'package:parking_system/parking_maker.dart';

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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingMaker()),
                  );
                },
                child: const Text("Parking Live View"),
              ),
            ),
          ],
        ));
  }
}
