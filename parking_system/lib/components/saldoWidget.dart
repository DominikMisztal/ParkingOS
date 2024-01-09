import 'package:flutter/material.dart';

class Saldo extends StatefulWidget {
  final saldo;

  //double saldoChange = 0;
  const Saldo({super.key, required this.saldo});

  @override
  State<Saldo> createState() => _SaldoState();
}

class _SaldoState extends State<Saldo> {
  void _chargeSaldo() {}

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                '${widget.saldo}zł',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              //Todo muszę to poprawić
              // widget.saldo += val!;
            });
            print('Dialog one returned value ---> $val');
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
          const SizedBox(height: 15),
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
