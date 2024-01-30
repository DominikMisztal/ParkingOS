import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/utils/Utils.dart';
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
  ParkingServices parkingServices = ParkingServices();
  UserService userService = UserService();
  List<Car> _placeholderCars = [];
  Car? selectedCar;
  Layover? tempTicket;
  @override
  void initState() {
    super.initState();
  }

  Future<List<Car>> fetchData() async {
    List<Car> cars = await userService.getCars();
    _placeholderCars = cars;
    return cars;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController carController = TextEditingController();

    var width = MediaQuery.of(context).size.width;

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
              FutureBuilder(
                future: fetchData(),
                builder: (context, AsyncSnapshot<List<Car>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading data'),
                    );
                  } else {
                    List<Car> data = snapshot.data!;
                    return DropdownMenu<Car>(
                      textStyle: const TextStyle(color: Colors.white60),
                      controller: carController,
                      requestFocusOnTap: true,
                      label: Text('Your Car: $selectedCar'),
                      onSelected: (Car? car) {
                        selectedCar = car;
                        setState(() {
                          selectedCar = car;
                          getTempTicket();
                        });
                      },
                      dropdownMenuEntries: _placeholderCars
                          .map<DropdownMenuEntry<Car>>((Car car) {
                        return DropdownMenuEntry<Car>(
                          value: car,
                          label:
                              '${car.brand} ${car.model} ${car.registration_num}',
                          style: MenuItemButton.styleFrom(
                            minimumSize: Size(width / 2,
                                30), //Todo można poprawić responsywność
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
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
                          FutureBuilder(
                            future: getTempTicket(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              return Container(
                                color: Colors.white,
                                child: QrImageView(
                                  data: '${tempTicket?.ticketDataForQRcode()}',
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _takeTicket();
                              Future.delayed(Duration(seconds: 2));
                              showToast('Ticket was taken');
                            },
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

  Future<bool> _takeTicket() async {
    double balance = await userService.getBalance();
    if (balance < 0) {
      showToast('Don\'t have enought funds, please charge your account');
      return false;
    }

    String? tempLogin = await userService.getLoginForCurrentUser();
    if (tempLogin == null) return false;
    tempLogin = tempLogin.replaceAll('.', '');

    Layover ticket = Layover(
        DateTime.now().toString(),
        "",
        widget.parking.name,
        widget.spot.number.toString(),
        selectedCar!.registration_num,
        tempLogin);

    parkingServices.startParking(widget.spot.number, widget.parking.name,
        selectedCar?.registration_num, widget.spot.floor, ticket, tempLogin);

    return true;
  }

  Future<Layover?> getTempTicket() async {
    String? tempLogin = await userService.getLoginForCurrentUser();
    if (tempLogin == null) return null;
    tempLogin = tempLogin.replaceAll('.', '');

    Layover ticket = Layover(
        DateTime.now().toString(),
        "",
        widget.parking.name,
        widget.spot.number.toString(),
        selectedCar!.registration_num,
        tempLogin);
    tempTicket = ticket;
    return ticket;
  }
}
