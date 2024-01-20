import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/parkfinder_page.dart';
import 'package:parking_system/user_page.dart';
import 'package:parking_system/user_payment.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/user_tickets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.user})
      : super(key: key);
  final UserDb user;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  List<Widget> pages = [];

  static get title => 'abc';
  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
    pages = [
      userPage(user: widget.user),
      Parkfinder(),
      UserTicketScreen(),
      Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 35),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User_Panel'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              unselectedTitleTextStyle: TextStyle(color: Colors.white60),
              unselectedIconColor: Colors.white60,
              displayMode: SideMenuDisplayMode.open,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 200,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Welcome: ',
                          style: TextStyle(color: Colors.white60, fontSize: 32),
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 16),
                        ),
                      ],
                    )),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    'Parking OS ©',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Account',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white60,
                ),
              ),
              SideMenuItem(
                title: 'Parkfinder',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.search),
              ),
              SideMenuItem(
                title: 'Tickets',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.airplane_ticket),
              ),
              SideMenuItem(
                title: 'Settings',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
