import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';
import 'package:parking_system/utils/Utils.dart';
import 'package:parking_system/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_system/services/user_auth.dart';
import 'package:parking_system/services/user_services.dart';

class SignUpUser extends StatelessWidget {
  final UserAuth _userAuth = UserAuth();
  final UserService _userService = UserService();

  SignUpUser({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  void _registerIfPossible(BuildContext context) async {
    UserCredential? userCredential = await _userAuth.signUp(emailController.text.trim(), passwordController.text.trim());
    if (userCredential != null) {
      UserDb user = UserDb(
          login: emailController.text,
          balance: 0,
          listOfCars: {},
          );
          _userService.addUser(userCredential.user!.uid, user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const motiveColor = Colors.amber;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
              ),
              Container(
                color: Colors.black87,
                width: (width / 3) * 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 128,
                      color: motiveColor,
                    ),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: motiveColor),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: MyCustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          obscureText: false,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: MyCustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: MyCustomTextField(
                          controller: passwordConfirmController,
                          labelText: 'Confirm Password',
                          obscureText: true,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerIfPossible(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill input')),
                              );
                            }
                          },
                          child: const Text('Create Account'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool validateAccount(String email, String password1, String password2) {
  return true;
}
