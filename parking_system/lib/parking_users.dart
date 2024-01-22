import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/parking_statistics.dart';

class ParkingUsers extends StatefulWidget {
  const ParkingUsers({super.key});

  @override
  State<ParkingUsers> createState() => _ParkingUsersState();
}

class _ParkingUsersState extends State<ParkingUsers> {
  final List<UserDb> _placeholderUsers = [
    UserDb(login: 'jankowalski@gmail.com', balance: 10, listOfCars: {
      'Car1': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'Abcd',
          expences: 100),
      'Car2': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'XYZQ',
          expences: 100),
      'Car3': Car(
          brand: 'Mercedes',
          model: 'Benz',
          registration_num: '1234',
          expences: 100),
    }),
    UserDb(login: 'marek.walczak@gmail.com', balance: 14, listOfCars: {
      'Car1': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'Abcd',
          expences: 100),
      'Car2': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'XYZQ',
          expences: 100),
      'Car3': Car(
          brand: 'Mercedes',
          model: 'Benz',
          registration_num: '1234',
          expences: 100),
    }),
    UserDb(login: 'marzena.janos@gmail.com', balance: 20, listOfCars: {
      'Car1': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'Abcd',
          expences: 100),
      'Car2': Car(
          brand: 'Scoda',
          model: 'Octavia',
          registration_num: 'XYZQ',
          expences: 100),
      'Car3': Car(
          brand: 'Mercedes',
          model: 'Benz',
          registration_num: '1234',
          expences: 100),
    })
  ];

  void deleteItem(int index) {
    setState(() {
      _placeholderUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Users'),
      ),
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: height - 30,
          width: width - 30,
          color: Colors.white,
        ),
        Container(
            width: width - 100,
            color: Colors.black87,
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Registered Users:',
                  style: TextStyle(fontSize: 32, color: Colors.white60),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: _placeholderUsers.length,
                        itemBuilder: ((context, index) {
                          return UserTile(
                            user: _placeholderUsers[index],
                            onDelete: () {
                              deleteItem(index);
                            },
                          );
                        }))),
              ],
            ))
      ]),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserDb user;
  final VoidCallback onDelete;
  const UserTile({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    List<Car> _userCars = user.listOfCars.values.toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.person,
                size: 32,
              ),
              Column(
                children: [Text(user.login), Text('balance: ${user.balance}')],
              ),
              SizedBox(
                width: 600,
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _userCars.length,
                    itemBuilder: ((context, index) {
                      return CarTile(car: _userCars[index]);
                    })),
              ),
              Column(
                children: [
                  const Text('Block User'),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.block,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarTile extends StatelessWidget {
  const CarTile({
    super.key,
    required this.car,
  });

  final Car car;

  @override
  Widget build(BuildContext context) {
    //Todo: Ask about how to do it
    void goToStatistics() {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => ParkingStatistics(
      //           category: 'Parking Spots',
      //           parkingName: ParkingLiveView.parkingName,
      //           spotId: currentlySelectedSpot.toString(),
      //           vehicleReg: '')),
      // );
    }

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 24,
            color: Colors.black87,
          ),
          SizedBox(width: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${car.model}\n${car.brand}\n${car.registration_num}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              goToStatistics();
            },
          ),
        ],
      ),
    );
  }
}
