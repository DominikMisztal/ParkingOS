import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/layover_model.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/models/Spot.dart';
import 'package:parking_system/models/spot_model.dart';
import 'package:parking_system/services/park_history.dart';
import 'package:parking_system/services/ticket_services.dart';
import 'package:parking_system/components/expense.dart';

class ExpensesServices {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('services');



Future<List<Expense>> loadExpensesForParking(String name) async {
  DataSnapshot snapshot = await _dbRef.child(name).get();
  List<Expense> expenses = [];
  if (snapshot.value != null) {
    List<dynamic> expensesMapList = snapshot.value as List<dynamic>;
    expenses = expensesMapList.map((map) {
      return Expense.fromMap(Map<String, dynamic>.from(map));
    }).toList();
  }
  return expenses;
}

  Future<ParkingDb?> saveExpensesForParking(String name, List<Expense> expenses) async {
    List<Map<String, dynamic>> expensesMapList = expenses.map((expense) => expense.toMap()).toList();
    await _dbRef.child(name).set(expensesMapList);
  }

}