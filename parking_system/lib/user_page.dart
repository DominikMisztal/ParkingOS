import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/carCard.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/user_services.dart';

class userPage extends StatefulWidget {
  const userPage({super.key, required this.user});
  final UserDb user;
  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  UserService userService = UserService();
  SaldoChargerModel scm = SaldoChargerModel();
  late double _totalSaldo = widget.user.balance;
  late UserDb user;
  
  List<Car> _placeholderCars = [
    Car(brand: 'Scoda', model: 'Octavia', registration_num: 'Abcd'),
    Car(brand: 'Scoda', model: 'Octavia', registration_num: 'XYZQ'),
    Car(brand: 'Mercedes', model: 'Benz', registration_num: '1234'),
  ];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _placeholderCars = user.userCars();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: height - 30,
        width: width - 30,
        color: Colors.white,
      ),
      Row(children: [
        Container(
            width: width / 3,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.black87,
                ),
                const SizedBox(height: 32),
                Text(
                  'User: ${widget.user.login}',
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(
                  Icons.edit,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Edit user Data',
                  style: TextStyle(decoration: TextDecoration.underline),
                ), //todo make it clickable
                const SizedBox(height: 32),
                Saldo(saldo: _totalSaldo, scm: scm),
              ],
            )),
        Container(
            width: width / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
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
