import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/components/carCard.dart';
import 'package:parking_system/components/car_form.dart';
import 'package:parking_system/components/edit_email_dialog.dart';
import 'package:parking_system/components/edit_password_dialog.dart';
import 'package:parking_system/components/saldoWidget.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/user_services.dart';
import 'package:parking_system/utils/Utils.dart';

class userPage extends StatefulWidget {
  const userPage({super.key, required this.user});
  final UserDb user;
  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  UserService userService = UserService();
  SaldoChargerModel scm = SaldoChargerModel();

  // bool canAddCar(registrationPlate) async{
  //   if(userService.canAddCar(registrationPlate)){
  //     return true;
  //   }
  //   return false;
  // }
  void getCars(Car car) async {
    bool? checkRegistration = await userService.canAddCar(car.registration_num);
    if (checkRegistration == null) return;
    //if(checkRegistration){
    await user.addCar(car);
    _placeholderCars = user.userCars();
    //}
    setState(() {
      _placeholderCars = user.userCars();
    });
  }

  void deleteCar(Car car) async {
    await user.deleteCar(car.registration_num);
    _placeholderCars.remove(car);
  }

  late double _totalSaldo = user.balance;
  late UserDb user;

  List<Car> _placeholderCars = [
    Car(
        brand: 'Scoda',
        model: 'Octavia',
        registration_num: 'Abcd',
        expences: 0),
    Car(
        brand: 'Scoda',
        model: 'Octavia',
        registration_num: 'XYZQ',
        expences: 0),
    Car(
        brand: 'Mercedes',
        model: 'Benz',
        registration_num: '1234',
        expences: 0),
  ];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    setBalance();
    _placeholderCars = user.userCars();
  }

  void setBalance() async {
    _totalSaldo = await userService.getBalance();
  }

  void deleteItem(int index) {
    setState(() {
      deleteCar(_placeholderCars[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: height - 30,
        width: width - 30,
        color: Colors.white,
      ),
      Row(children: [
        Container(
            width: width / 3,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.black87,
                ),
                const SizedBox(height: 32),
                Text(
                  'User: ${widget.user.login}',
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(
                  Icons.edit,
                  size: 32,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ChangePasswordDialog(
                        user: widget.user,
                        onChanged: (newEmail) {
                          showToast('Password actualized');
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Password',
                    style: TextStyle(
                        fontSize: 16, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 32),
                Saldo(
                  saldo: _totalSaldo,
                  scm: scm,
                  user: this.user,
                ),
              ],
            )),
        Container(
            width: width / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Icon(
                  Icons.directions_car,
                  size: 64,
                  color: Colors.black87,
                ),
                const Text(
                  'Cars',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Center(
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _placeholderCars.length,
                      itemBuilder: (context, index) {
                        return carCard(
                          car: _placeholderCars[index],
                          carList: _placeholderCars,
                          onDelete: () {
                            deleteItem(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    Car? newCar = await showDialog(
                      context: context,
                      builder: (context) => CarForm(
                        onSubmit: (car) {
                          setState(() {
                            if (car.registration_num == null ||
                                car.registration_num.isEmpty) {
                              showToast('Registration must not be empty');
                              return;
                            }
                            if (car.registration_num.length > 7 ||
                                car.registration_num.length < 5) {
                              showToast('Invalid registration format');
                              return;
                            }
                            // bool canAddCar = await userService.canAddCar(car.registration_num);
                            // if(){
                            getCars(car);
                            //deleteCar(car);
                            //MapEntry<String, Car> entry = MapEntry(car.registration_num, car);
                            //user.listOfCars.addEntries(entry);
                            //_placeholderCars.add(car);
                            //}
                          });
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ))
      ])
    ]);
  }
}
