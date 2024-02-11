import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/models/parkingDB.dart';
import 'package:parking_system/components/expense.dart';

class ExpensesServices {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('services');
  final DatabaseReference _dbRef2 =
      FirebaseDatabase.instance.ref().child('parking_history');

Future<double> loadIncomeForParking(String name, DateTime incomeFromWhen) async {
  double income = 0;
  DataSnapshot snapshot = await _dbRef2.child(name).get();
  
  if (snapshot.value != null) {
    dynamic data = snapshot.value;

    if (data is Map) {
      Map<dynamic, dynamic> spotsData = data;
      
      spotsData.forEach((spotId, incomeRecords) {
        _processIncomeRecords(incomeRecords, incomeFromWhen, (double tempIncome) {
          income += tempIncome;
        });
      });
    } else if (data is List) {
      List<dynamic> spotsList = data;
      
      for (var incomeRecords in spotsList) {
        _processIncomeRecords(incomeRecords, incomeFromWhen, (double tempIncome) {
          income += tempIncome;
        });
      }
    }
  }
  
  return income;
}

void _processIncomeRecords(dynamic incomeRecords, DateTime incomeFromWhen, Function(double) processIncome) {
  if (incomeRecords is Map) {
    incomeRecords.forEach((timestamp, incomeData) {
      DateTime check = DateTime.parse(incomeData['parkingEnded']);
      if (incomeFromWhen.month == check.month && incomeFromWhen.year == check.year) {
        double tempIncome = double.parse(incomeData['income'].toString());
        processIncome(tempIncome);
      }
    });
  }
}

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

  Future<ParkingDb?> saveExpensesForParking(
      String name, List<Expense> expenses) async {
    List<Map<String, dynamic>> expensesMapList =
        expenses.map((expense) => expense.toMap()).toList();
    await _dbRef.child(name).set(expensesMapList);
  }
}
