import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';

class carCard extends StatelessWidget {
  final Car car;

  const carCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.directions_car),
        title: Text('${car.brand} ${car.model}'),
        subtitle: Text(car.registration_num),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
