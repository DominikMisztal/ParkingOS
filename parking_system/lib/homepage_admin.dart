import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page Admin'),
        ),
        body: Column(
          children: [
            Text(email),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back!"),
              ),
            ),
          ],
        ));
  }
}