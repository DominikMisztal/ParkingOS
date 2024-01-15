import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';

class CarForm extends StatefulWidget {
  final Function(Car) onSubmit;

  CarForm({required this.onSubmit});

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a New Car'),
      content: Column(
        children: [
          TextFormField(
            controller: _brandController,
            decoration: InputDecoration(labelText: 'Brand'),
            style: TextStyle(color: Colors.white60),
          ),
          TextFormField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
              style: TextStyle(color: Colors.white60)),
          TextFormField(
            controller: _registrationController,
            decoration: InputDecoration(labelText: 'Registration Number'),
            style: TextStyle(color: Colors.white60),
            validator: validateRegistrationNumber,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Car newCar = Car(
              brand: _brandController.text,
              model: _modelController.text,
              registration_num: _registrationController.text,
            );
            widget.onSubmit(newCar);
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

String? validateRegistrationNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Registration number is required';
  }
  RegExp regExp = RegExp(r'^[A-Z0-9]');
  if (!regExp.hasMatch(value)) {
    return 'Invalid registration number';
  }
  return null;
}
