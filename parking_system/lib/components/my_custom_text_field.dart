import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  const MyCustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    required this.obscureText,
    this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white70),
          obscureText: obscureText,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.white60)),
          validator: validator),
    );
  }
}
