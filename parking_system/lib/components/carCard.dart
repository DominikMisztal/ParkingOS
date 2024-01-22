import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';

class carCard extends StatefulWidget {
  final Car car;
  final List<Car> carList; //easiest way to delete
  final VoidCallback onDelete;
  const carCard(
      {super.key,
      required this.car,
      required this.carList,
      required this.onDelete});

  @override
  State<carCard> createState() => _carCardState();
}

class _carCardState extends State<carCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: const Icon(Icons.directions_car),
          title: Text('${widget.car.brand} ${widget.car.model}'),
          subtitle: Text(widget.car.registration_num),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _editCar(widget.car);
            },
          )),
    );
  }

  //Todo Connect with database
  void _editCar(Car car) {
    _showDeleteDialog(car);
  }

  Future<void> _showDeleteDialog(Car car) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item',
              style: TextStyle(color: Colors.white60, fontSize: 16)),
          content: const Text(
            'Are you sure you want to delete this item?',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onLongPress: widget.onDelete,
              onPressed: () {
                widget.onDelete();
                // Remove the item from the list
                setState(() {
                  widget.carList.remove(car);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
