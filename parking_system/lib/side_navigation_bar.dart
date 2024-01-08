import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:parking_system/user_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  List<Widget> pages = [
    userPage(username: title),
    Container(
      color: const Color.fromARGB(255, 1, 1, 1),
      child: const Center(
        child: Text(
          'ParkFinder',
          style: TextStyle(fontSize: 35),
        ),
      ),
    ),
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

  static get title => 'abc';

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              displayMode: SideMenuDisplayMode.auto,
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
