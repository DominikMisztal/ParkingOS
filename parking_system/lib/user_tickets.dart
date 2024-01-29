import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/payment_calculator.dart';
import 'package:parking_system/services/ticket_services.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserTicketScreen extends StatefulWidget {
  const UserTicketScreen({super.key, required this.user});
  final UserDb user;
  @override
  State<UserTicketScreen> createState() => UserPaymentStateScreen();
}

//Todo Do połączenia z bazą i wykminienia co zrobić z płatnością i taryfą.
class UserPaymentStateScreen extends State<UserTicketScreen> {
  ParkingServices parkingServices = ParkingServices();
  TicketService ticketService = TicketService();
  Future<List<Layover>> getLayovers() async {
    //Todo
    List<Layover> lays = [];
    return lays;
  }

  List<Layover> layovers = [
    Layover('2024-01-26 13:00:00', '', 'The Greatest Park', '23', 'Abcd1',
        "userImplementIGuess?"),
  ];
  Layover? ticket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTicket();
  }

  void initializeTicket() async {
    Layover? tempTicket = await ticketService.findTicket(widget.user.login);
    ticket = tempTicket!;
    print(tempTicket);
  }

  Widget build(BuildContext context) {
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
          child: Expanded(
            child: Column(
              children: [
                layovers.isEmpty
                    ? const Text('There is no active ticket',
                        style: TextStyle(color: Colors.white60, fontSize: 32))
                    : _layoverItem(layovers[0]),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _layoverItem(Layover layover) {
    return Container(
      child: Column(
        children: [
          const Text(
            'Active Ticket:',
            style: TextStyle(color: Colors.white60, fontSize: 32),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            color: Colors.white,
            child: QrImageView(
              data: '${layover.car} ',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Date: ${layover.startDate}',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Text(
            'Parking: ${layover.parkingId}',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Text(
            'Spot: ${layover.spotId}',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          //Todo Fajnie byłoby tu dać stoper odmierzający czas parkingu
          ElevatedButton(
              onPressed: () {
                _giveBackTicket(layover);
              },
              child: Text('Give Ticket Back'))
        ],
      ),
    );
  }

  Future<double> countCost(Layover layover) async {
    ParkingServices parkingServices = ParkingServices();
    Map<String, List<double>> tarifs =
        await parkingServices.getTarifs(layover.parkingId);
    PaymentCalculator paymentCalculator = PaymentCalculator(tariffsMap: tarifs);
    return paymentCalculator.calculatePaymentFromTime(
        DateTime.parse(layover.startDate), DateTime.now());
  }

  void _giveBackTicket(Layover layover) async {
    //Add end to layover and update database
    layover.endDate = DateTime.now().toString();
    double cost = await countCost(layover);
    if (cost < widget.user.balance) {
      parkingServices.moveFromParking(int.parse(layover.spotId),
          layover.parkingId, cost, widget.user.login);
      UserService userService = UserService();
      double newBalance = await userService.getBalance();
      userService.addBalance(newBalance - cost);
      widget.user.addBalance(-cost);
      setState(() {
        layovers.clear();
      });
    }
    //Clean Layover list
  }
}
