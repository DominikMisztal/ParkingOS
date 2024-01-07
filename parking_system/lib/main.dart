import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/signup.dart';
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
      title: 'ParkingOS login',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(title: 'Parking OS login'),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),

              // login and sign up buttons
              Row(children: [
                Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if(validateAccount(emailController.text, passwordController.text)){
                          if(emailController.text == "admin"){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePageAdmin(
                                email: emailController.text,
                            )),
                          ); 
                          }
                          else{
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePageUser(
                                email: emailController.text,
                            )),
                          ); 
                          }
                          
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incorrect password')),
                        );
                        } 
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                ),

                SizedBox(width: 10,),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpUser()),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ),
            ],)
              



            ],
          ),
        ),
      ),
    );
  }
}


bool validateAccount(String email, String password){
  return true;
}


