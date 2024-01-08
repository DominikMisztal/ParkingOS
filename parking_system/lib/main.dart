import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/signup.dart';
import 'package:parking_system/login.dart';
import 'homepage_user.dart';
import 'homepage_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyDB9SmkdIu25FJybiKHkI3Cue0tF4HhTkE",
    projectId: "flutter-parking-system",
    messagingSenderId: "1099263235530",
    appId: "1:1099263235530:web:8d25ce135607d68bf3ab33",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'ParkingOS login',
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: const TextStyle(
              fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white60),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber, background: Colors.black87),
        useMaterial3: true,
      ),
      home: const Login(title: 'Parking OS login'),
    );
  }
}
