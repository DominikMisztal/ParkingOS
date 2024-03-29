import 'package:flutter/material.dart';
import 'package:parking_system/services/user_auth.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/utils/Utils.dart';

import '../models/user.dart';

class Saldo extends StatefulWidget {
  final double saldo;
  final SaldoChargerModel scm;
  final UserDb user;
  const Saldo(
      {super.key, required this.saldo, required this.scm, required this.user});

  @override
  State<Saldo> createState() => _SaldoState(user: this.user);
}

class _SaldoState extends State<Saldo> {
  final UserDb user;

  _SaldoState({required this.user});
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    double _ssaldo = widget.saldo;
    return Column(
      children: [
        const Center(
          child: Text(
            'Saldo:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(80)),
          child: Container(
            color: Colors.white60,
            width: 100,
            height: 100,
            child: Center(
              child: ListenableBuilder(
                listenable: widget.scm,
                builder: (BuildContext context, Widget? child) {
                  _ssaldo += widget.scm.charge;
                  userService.addBalance(_ssaldo);
                  user.addBalance(widget.scm.charge);
                  return Text(
                    '${_ssaldo}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            double? val = await showDialog<double>(
              context: context,
              builder: (context) => ChargeDialog(
                val: widget.saldo,
              ),
            );
            setState(() {
              widget.scm.chargeSaldo(val ?? 0);
            });
          },
          child: const Text('Charge'),
        ),
      ],
    );
  }
}

class ChargeDialog extends StatefulWidget {
  @override
  _ChargeDialogState createState() => _ChargeDialogState();

  final double val;

  ChargeDialog({
    required this.val,
  });
}

class _ChargeDialogState extends State<ChargeDialog> {
  double value = 0;
  bool validData = false;
  bool numericValue = false;
  @override
  void initState() {
    super.initState();
    value = widget.val;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white60),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter a number',
            ),
            onChanged: (val) {
              setState(() {
                // Update enteredNumber when the text changes
                try {
                  value = double.parse(val);
                  numericValue = true;
                  if (value >= 10) {
                    validData = true;
                  } else {
                    validData = false;
                  }
                } catch (e) {
                  numericValue = false;
                  validData = false;
                  value = 0;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: (() {
              if (validData) {
                Navigator.pop(context, value);
              } else {
                if (numericValue) {
                  showToast("Please enter value that's 10 or higher");
                } else {
                  showToast("Please enter a number");
                }
              }
            }),
            child: const Text('Charge'),
          ),
        ],
      ),
    );
  }
}

class SaldoChargerModel with ChangeNotifier {
  UserAuth userAuth = UserAuth();
  double _charge = 0;
  double get charge => _charge;

  void chargeSaldo(double price) {
    if (price < 0) {
      showToast('Charge have to be bigger than 0');
      return;
    }
    _charge += price;
    notifyListeners();
  }
}
