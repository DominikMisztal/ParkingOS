import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/services/park_history.dart';

class TicketService {
  ParkHistory parkHistory = ParkHistory();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('tickets');

  void addTicket(Layover ticket, String ticketKey) async {
    Map<String, dynamic> ticketMap = {
      'startDate': ticket.startDate,
      'endDate': ticket.endDate,
      'parkingId': ticket.parkingId,
      'spotId': ticket.spotId,
      'car': ticket.car,
    };

    _dbRef.child(ticketKey).set(ticketMap);
  }

  Future<void> updateTicketEndDate(String holderOfTicket) async {
    holderOfTicket = holderOfTicket.replaceAll('.', '');
    DataSnapshot snapshot =
        await _dbRef.child(holderOfTicket.replaceAll('.', '')).get();

    if (snapshot.value != null) {
      Map<String, dynamic> ticketData = snapshot.value as Map<String, dynamic>;
      ticketData['endDate'] = DateTime.now().toString();
      await _dbRef.child(holderOfTicket).update(ticketData);
    }
  }

  Future<Layover?> findTicket(String userId) async {
    DataSnapshot snapshot = await _dbRef.get();

    if (snapshot.value != null) {
      try {
        Map<dynamic, dynamic> ticketsData =
            snapshot.value as Map<dynamic, dynamic>;

        for (var ticketKey in ticketsData.keys) {
          Map<String, dynamic> ticketMap =
              ticketsData[ticketKey] as Map<String, dynamic>;
          Layover ticket = Layover.fromMap(ticketMap);
          if (ticketKey == userId.replaceAll('.', '')) {
            if (ticket.endDate == '') {
              return ticket;
            } else {
              return null;
            }
          }
        }
      } catch (e) {
        print('Error parsing snapshot value: $e');
        return null;
      }
    }
    return null;
  }
}
