import 'package:flutter/material.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/park_services.dart';
import 'package:parking_system/services/payment_calculator.dart';
import 'package:parking_system/services/ticket_services.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

GlobalKey<UserPaymentStateScreen> myWidgetKey =
    GlobalKey<UserPaymentStateScreen>();

class UserTicketScreen extends StatefulWidget {
  const UserTicketScreen({super.key, required this.user});
  final UserDb user;
  @override
  State<UserTicketScreen> createState() => UserPaymentStateScreen();
}

class UserPaymentStateScreen extends State<UserTicketScreen> {
  void forceRefresh() {
    // Access the widget state using the key and trigger a rebuild
    (widget.key as GlobalKey<UserPaymentStateScreen>)
        .currentState
        ?.setState(() {
      // Update your widget state or perform any tasks that trigger a rebuild
    });
  }

  ParkingServices parkingServices = ParkingServices();
  TicketService ticketService = TicketService();

  Layover? ticket;
  @override
  void initState() {
    super.initState();
  }

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
            child: FutureBuilder(
              future: initializeTicket(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading data'),
                  );
                }
                if (snapshot.data == null) {
                  return const Column(
                    children: [
                      Text('There is no active ticket',
                          style:
                              TextStyle(color: Colors.white60, fontSize: 32)),
                    ],
                  );
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      _layoverItem(snapshot.data),
                    ],
                  );
                }
                return Container();
              },
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
              data: layover.ticketDataForQRcode(),
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Start Date: ${layover.startDate}',
            style: const TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Text(
            'Parking: ${layover.parkingId}',
            style: const TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Text(
            'Spot: ${layover.spotId}',
            style: const TextStyle(color: Colors.white60, fontSize: 16),
          ),
          ElevatedButton(
              onPressed: () {
                _giveBackTicket(layover);
                setState(() {});
              },
              child: const Text('Give Ticket Back and Confirm')),
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

  Future<bool> _giveBackTicket(Layover layover) async {
    try {
      layover.endDate = DateTime.now().toString();
      double cost = await countCost(layover);
      if (cost < widget.user.balance) {
        setState(() {
          ticket = null;
          myWidgetKey.currentState?.forceRefresh();
        });
        parkingServices.moveFromParking(int.parse(layover.spotId),
            layover.parkingId, cost, widget.user.login);
        UserService userService = UserService();
        double newBalance = await userService.getBalance();
        widget.user.balance = newBalance;
        userService.addBalance(newBalance - cost);
        widget.user.addBalance(-cost);
      }
    } catch (e) {}
    setState(() {
      ticket = null;
    });
    return true;
  }
}
