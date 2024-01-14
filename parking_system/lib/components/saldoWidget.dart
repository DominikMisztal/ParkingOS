import 'package:flutter/material.dart';

class Saldo extends StatefulWidget {
  final double saldo;
  final SaldoChargerModel scm;
  const Saldo({super.key, required this.saldo, required this.scm});

  @override
  State<Saldo> createState() => _SaldoState();
}

class _SaldoState extends State<Saldo> {
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
            style: TextStyle(color: Colors.white60),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter a number',
            ),
            onChanged: (val) {
              setState(() {
                // Update enteredNumber when the text changes
                value = double.tryParse(val) ?? 0;
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
            onPressed: () => Navigator.pop(context, value),
            child: const Text('Charge'),
          ),
        ],
      ),
    );
  }
}

class SaldoChargerModel with ChangeNotifier {
  double _charge = 0;
  double get charge => _charge;

  void chargeSaldo(double price) {
    _charge += price;
    notifyListeners();
  }
}
