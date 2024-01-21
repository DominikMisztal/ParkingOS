import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parking_model.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserTicketScreen extends StatefulWidget {
  const UserTicketScreen({
    super.key,
  });

  @override
  State<UserTicketScreen> createState() => UserPaymentStateScreen();
}

//Todo Do połączenia z bazą i wykminienia co zrobić z płatnością i taryfą.
class UserPaymentStateScreen extends State<UserTicketScreen> {
  Future<List<Layover>> getLayovers() async {
    //Todo
    List<Layover> lays = [];
    return lays;
  }

  List<Layover> layovers = [
    Layover(DateTime.now().toString(), '', 'Great Parking', '23',
        Car(brand: 'Scoda', model: 'Octavia', registration_num: 'Abcd1')),
  ];
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
              data: '${layover.car.registration_num} ',
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

  void _giveBackTicket(Layover layover) async {
    //Add end to layover and update database
    layover.endDate = DateTime.now().toString();

    //Clean Layover list
    setState(() {
      layovers.clear();
    });
  }
}
