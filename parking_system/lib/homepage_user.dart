import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePageUser extends StatelessWidget {
  const HomePageUser({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page User'),
        ),
        body: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: width - 100,
                  height: height - 100,
                  color: Colors.amber,
                ),
                Container(
                  width: width / 3 * 2,
                  height: height / 3 * 2,
                  color: Colors.grey,
                ),
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
            )
          ],
        ));
  }
}
