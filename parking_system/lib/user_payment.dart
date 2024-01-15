import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen(
      {super.key, required this.parking, required this.spot});
  final Parking parking;
  final Spot spot;
  @override
  State<UserPaymentScreen> createState() => UserPaymentStateScreen();
}

class UserPaymentStateScreen extends State<UserPaymentScreen> {
  List<Car> _placeholderCars = [
    Car(brand: 'Scoda', model: 'Octavia',  registration_num : 'Abcd'),
    Car(brand: 'Scoda', model:'Octavia',  registration_num : 'XYZQ'),
    Car(brand: 'Mercedes', model: 'Benz',  registration_num : '1234'),
  ];
  Car? selectedCar;
//Todo jest dosyć brzydko, uporządkuję to o ile znajdę czas
  @override
  Widget build(BuildContext context) {
    final TextEditingController carController = TextEditingController();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          color: Colors.white,
        ),
        Container(
          width: width * 3 / 4,
          color: Colors.black87,
        ),
        Container(
          width: width / 3 * 2,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Parking: ${widget.parking.name}\n'
                'Adress: ${widget.parking.adress}\n'
                'Spot number: ${widget.spot.number}',
                style: const TextStyle(fontSize: 16, color: Colors.white60),
              ),
              const SizedBox(height: 16),
              const Text('Select a Car:',
                  style: TextStyle(fontSize: 32, color: Colors.white60)),
              const SizedBox(height: 16),
              DropdownMenu<Car>(
                textStyle: TextStyle(color: Colors.white60),
                //initialSelection: _placeholderCars.first,
                controller: carController,
                requestFocusOnTap: true,
                label: Text('Your Car: $selectedCar'),
                onSelected: (Car? car) {
                  selectedCar = car;
                  print(selectedCar);
                  setState(() {
                    print(car?.brand);
                    selectedCar = car;
                  });
                },
                dropdownMenuEntries:
                    _placeholderCars.map<DropdownMenuEntry<Car>>((Car car) {
                  return DropdownMenuEntry<Car>(
                    value: car,
                    label: '${car.brand} ${car.model} ${car.registration_num}',
                    style: MenuItemButton.styleFrom(
                      minimumSize: Size(
                          width / 2, 30), //Todo można poprawić responsywność
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    if (selectedCar != null)
                      Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 32,
                          ),
                          Container(
                            color: Colors.white,
                            child: QrImageView(
                              data: '${selectedCar?.registration_num}',
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Take a ticket'),
                          ),
                        ],
                      )
                    else
                      const Text('Please select a car'),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
