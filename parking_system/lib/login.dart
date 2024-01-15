import 'package:flutter/material.dart';
import 'package:parking_system/components/my_custom_text_field.dart';
import 'package:parking_system/side_navigation_bar.dart';
import 'package:parking_system/signup.dart';
import 'package:parking_system/services/user_auth.dart';
import 'homepage_admin.dart';
import 'package:parking_system/utils/Utils.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Color motiveColor = Colors.amber;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final UserService _userService = UserService();
  final UserAuth _userAuth = UserAuth();

  Future<void> _loginIfPossible() async {
    UserCredential? userCredential = await _userAuth.signIn(
        emailController.text.trim(), passwordController.text.trim());
    if (userCredential != null) {
      UserDb? user = await _userService.getUserByUID(userCredential.user!.uid);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: emailController.text,
              user: user,
            ),
          ),
        );
      } else {
        showToast("User details not found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void _login() {
      if (_formKey.currentState!.validate()) {
        if (validateAccount(emailController.text, passwordController.text)) {
          if (emailController.text == "admin") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageAdmin(
                        email: emailController.text,
                      )),
            );
          } else {
            _loginIfPossible();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill input')),
        );
      }
    }

    void _navigateToSignUp() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpUser()),
      );
    }

    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                color: Colors.black87,
                width: (width / 3) * 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Parking OS',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: motiveColor),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.directions_car,
                      size: 128,
                      color: motiveColor,
                    ),
                    const Text(
                      'Login',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            }
                            return null;
                          }),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: MyCustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          }),
                    ),

                    // login button

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account yet?',
                          style: TextStyle(color: motiveColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: _navigateToSignUp,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

bool validateAccount(String email, String password) {
  return true;
}
