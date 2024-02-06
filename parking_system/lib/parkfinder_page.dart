import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';

import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/payment_calculator.dart';
import 'package:parking_system/services/ticket_services.dart';

import 'package:parking_system/user_payment.dart';
import 'package:parking_system/utils/Utils.dart';

class Parkfinder extends StatefulWidget {
  const Parkfinder({super.key, required this.user});
  final UserDb user;
  @override
  State<Parkfinder> createState() => _ParkfinderState();
}

class _ParkfinderState extends State<Parkfinder> {
  ParkingServices parkingServices = ParkingServices();
  TicketService ticketService = TicketService();
  void _navigateToPayment(Parking parking, Spot spot) {
    if (ticket != null) {
      showToast('You already have an active ticket, pay for it first');
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPaymentScreen(
                parking: parking,
                spot: spot,
                user: widget.user,
              )),
    );
  }

  Layover? ticket;
  Future<Layover?> initializeTicket() async {
    Layover? tempTicket = await ticketService.findTicket(widget.user.login);
    if (tempTicket == null) {
      ticket = null;
      return null;
    }
    tempTicket = tempTicket;
    ticket = tempTicket;
    print(ticket?.startDate.toString());
    return tempTicket;
  }

  Map<String, List<double>> tariffsMap = {
    '0': [2, 3, 4],
    '12': [4, 5, 6]
  };
  final parkingTimeController = TextEditingController();
  double requiredPayment = 0;
  late Parking currentParking;
  List<Spot> filteredSpaces = [];
  List<ParkingDb> parkingsDb = [];

  @override
  void initState() {
    filteredSpaces = [];
    super.initState();
    addParkings();
    initializeTicket();
  }

  void addParkings() async {
    List<ParkingDb>? tempParkingsDb = await parkingServices.getParkings();
    if (tempParkingsDb != null) {
      parkingsDb = tempParkingsDb;
    }

    for (var parking in parkingsDb) {
      //todo: add tarifs
      parkings.add(Parking(parking.address, parking.name, parking.address,
          parking.level, parking.height * parking.width, 1));
      for (var spot in parking.spots) {
        spots.add(Spot(parking.address, spot.level, spot.idNumber,
            spot.registrationNumber == "" ? false : true));
      }
    }
  }

  List<Parking> parkings = [];
  List<Spot> spots = [];

  void filterSpaces(Parking parking) {
    List<Spot> searchResult = spots
        .where((spot) => !spot.isTaken && spot.parkingId == parking.parkingId)
        .toList();

    setState(() {
      filteredSpaces = searchResult;
    });
  }

  Map<String, double> parkingsAndPayments = {};

  double findCheapestStay(int stayDuration) {
    DateTime now = DateTime.now();
    double lowestPayment = -1;
    for (var parking in parkings) {
      //add tariff to each parking
      String name = parking.name;
      PaymentCalculator calculator = PaymentCalculator(tariffsMap: tariffsMap);
      double payment = calculator.calculatePaymentFromHours(now, stayDuration);
      parkingsAndPayments[name] = payment;
      if (lowestPayment == -1) {
        lowestPayment = payment;
      }
      if (payment < lowestPayment) {
        lowestPayment = payment;
      }
    }
    sortParkingsAndPayments();
    return lowestPayment;
  }

  void sortParkingsAndPayments() {
    var sortedEntries = parkingsAndPayments.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    parkingsAndPayments = Map.fromEntries(sortedEntries);
  }

  void listener() {
    String text = parkingTimeController.text;
    try {
      if (text.isEmpty) {
        requiredPayment = 0.0;
      } else {
        int stayDuration = int.parse(text);
        setState(() {
          if (stayDuration < 1) {
            requiredPayment = 0.0;
          } else {
            requiredPayment = findCheapestStay(stayDuration);
          }
        });
      }
    } on Exception catch (_) {
      requiredPayment = 0.0;
    }
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    parkingTimeController.addListener(listener);

    return FutureBuilder(
      future: initializeTicket(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return AbsorbPointer(
            absorbing: ticket != null ? true : false,
            child: ticket == null
                ? Stack(alignment: AlignmentDirectional.center, children: [
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          MyCustomTextField(
                              controller: parkingTimeController,
                              labelText: 'Enter time',
                              obscureText: false),
                          Padding(padding: EdgeInsets.all(10)),
                          Text(
                            requiredPayment.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
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
                          SearchAnchor(builder: (BuildContext context,
                              SearchController controller) {
                            return SearchBar(
                              controller: controller,
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                              leading: const Icon(Icons.search),
                            );
                          }, suggestionsBuilder: (BuildContext context,
                              SearchController controller) {
                            return List<ListTile>.generate(parkings.length,
                                (int index) {
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
                                  subtitle: Text(filteredSpaces[index].isTaken
                                      ? 'Occupied'
                                      : 'Free'),
                                  onTap: () {
                                    //Navigate to payment
                                    _navigateToPayment(
                                        currentParking, filteredSpaces[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])
                : Text(
                    'Pay your current ticket first',
                    style: TextStyle(color: Colors.white70, fontSize: 72),
                  ));
      },
    );
  }
}
