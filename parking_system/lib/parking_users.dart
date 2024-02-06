import 'package:flutter/material.dart';
import 'package:parking_system/models/car_model.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/parking_statistics.dart';
import 'package:parking_system/services/user_services.dart';

class ParkingUsers extends StatefulWidget {
  const ParkingUsers({super.key});

  @override
  State<ParkingUsers> createState() => _ParkingUsersState();
}

class _ParkingUsersState extends State<ParkingUsers> {
  UserService userService = UserService();
  bool updateUsersFromDB = true;
  Future<List<UserDb>> addUsers() async {
    if (updateUsersFromDB == true) {
      List<UserDb> users = await userService.getAllUsers();
      _placeholderUsers.clear();
      _placeholderUsers.addAll(users);
      return users;
    } else {
      updateUsersFromDB = true;
      return _placeholderUsers;
    }
  }

  @override
  void initState() {
    super.initState();
    addUsers();
  }

  final List<UserDb> _placeholderUsers = [];

  void deleteItem(int index) {
    setState(() {
      _placeholderUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Users'),
      ),
      body: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: height - 30,
          width: width - 30,
          color: Colors.white,
        ),
        Container(
            width: width - 100,
            color: Colors.black87,
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Registered Users:',
                  style: TextStyle(fontSize: 32, color: Colors.white60),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: addUsers(),
                      builder: (context, AsyncSnapshot<List<UserDb>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error loading data'),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: _placeholderUsers.length,
                              itemBuilder: ((context, index) {
                                return UserTile(
                                  user: _placeholderUsers[index],
                                  onBlock: () {
                                    setState(() {
                                      updateUsersFromDB = false;
                                      _placeholderUsers[index].blocked =
                                          !_placeholderUsers[index].blocked;
                                      userService.blockUser(
                                          _placeholderUsers[index].login,
                                          _placeholderUsers[index].blocked);
                                    });
                                  },
                                );
                              }));
                        }
                      }),
                ),
              ],
            ))
      ]),
    );
  }
}

class UserTile extends StatefulWidget {
  final UserDb user;
  final VoidCallback onBlock;
  const UserTile({super.key, required this.user, required this.onBlock});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final ScrollController _scrollController = ScrollController();
  late Color tileColor;
  late String blockText;
  void changeOnBlocked() {
    setState(() {
      blockText = widget.user.blocked == true ? 'Unblock user' : 'Block user';
      tileColor = widget.user.blocked == true ? Colors.grey : Colors.white;
    });
  }

  @override
  void initState() {
    super.initState();
    blockText = widget.user.blocked == true ? 'Unblock user' : 'Block user';
    tileColor = widget.user.blocked == true ? Colors.grey : Colors.white;
  }

  void _scroll(int direction) {
    final currentPosition = _scrollController.position.pixels;
    const itemWidth = 600.0;

    _scrollController.animateTo(
      currentPosition + (itemWidth * direction),
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Car> _userCars = widget.user.listOfCars.values.toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: tileColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.person,
                size: 32,
              ),
              Column(
                children: [
                  Text(widget.user.login),
                  Text('balance: ${widget.user.balance}')
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _scroll(-1);
                    },
                  ),
                  SizedBox(
                    width: 600,
                    height: 80,
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _userCars.length,
                        itemBuilder: ((context, index) {
                          return CarTile(car: _userCars[index]);
                        })),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _scroll(1);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(blockText),
                  IconButton(
                    onPressed: () {
                      widget.onBlock();
                      changeOnBlocked();
                    },
                    icon: const Icon(
                      Icons.block,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarTile extends StatelessWidget {
  const CarTile({
    super.key,
    required this.car,
  });

  final Car car;

  @override
  Widget build(BuildContext context) {
    void goToStatistics() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParkingStatistics(
                category: 'Vehicles',
                parkingName: '',
                spotId: '',
                vehicleReg: car.registration_num)),
      );
    }

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_car,
            size: 24,
            color: Colors.black87,
          ),
          const SizedBox(width: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${car.model}\n${car.brand}\n${car.registration_num}',
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              goToStatistics();
            },
          ),
        ],
      ),
    );
  }
}
