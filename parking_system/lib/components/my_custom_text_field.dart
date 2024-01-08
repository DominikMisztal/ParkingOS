import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  const MyCustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white70),
      obscureText: obscureText,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white60)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
