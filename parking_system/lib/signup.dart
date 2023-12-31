import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';

class SignUpUser extends StatelessWidget {
  SignUpUser({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

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
                              Navigator.pop(context);
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
