import 'package:flutter/material.dart';
import 'package:parking_system/components/carCard.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';

class userPage extends StatefulWidget {
  const userPage({super.key, required this.username});
  final String username;
  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  List<Car> _placeholderCars = [
    Car('Scoda', 'Octavia', 'Abcd'),
    Car('Scoda', 'Octavia', 'XYZQ'),
    Car('Mercedes', 'Benz', '1234'),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: height - 30,
        width: width - 30,
        color: Colors.white60,
      ),
      Row(children: [
        Container(
            width: width / 3,
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.black87,
                ),
                const SizedBox(height: 32),
                Text(
                  'User: ${widget.username}',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                const Saldo(saldo: 50)
              ],
            )),
        Container(
            width: width / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_car,
                  size: 64,
                  color: Colors.black87,
                ),
                const Text(
                  'Cars',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Center(
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: _placeholderCars.length,
                      itemBuilder: (context, index) {
                        return carCard(car: _placeholderCars[index]);
                      },
                    ),
                  ),
                ),
              ],
            ))
      ])
    ]);
  }
}
