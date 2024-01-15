import 'package:flutter/material.dart';

class ParkingTile extends StatelessWidget {
  final int id;
  const ParkingTile({super.key, required this.id});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        // Add your onTap logic here
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.black,
            width: 2
          ),
        ),
        child: Center(
          child: Text("ID:" + id.toString())
          )
      ),
    );
  }
}