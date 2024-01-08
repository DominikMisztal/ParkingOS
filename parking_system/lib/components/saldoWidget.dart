import 'package:flutter/material.dart';

class Saldo extends StatelessWidget {
  final int saldo;
  const Saldo({super.key, required this.saldo});

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
                  '${saldo}zł',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ],
    );
  }
}
