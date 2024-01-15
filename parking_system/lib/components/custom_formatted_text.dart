import 'package:flutter/material.dart';

class CustomFormattedText extends StatelessWidget {
  final text;
  const CustomFormattedText({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
