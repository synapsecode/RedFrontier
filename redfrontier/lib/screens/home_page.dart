import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/navextensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/screens/chat/all_chats/all_chats.dart';
import 'package:redfrontier/screens/home_screen.dart';
import 'package:redfrontier/screens/maps_screen.dart';
import 'package:redfrontier/screens/news_screen.dart';
import 'package:redfrontier/screens/report_screen.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:redfrontier/screens/resources/dashboard.dart';
import 'package:redfrontier/services/auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _title = ['News', 'Home', 'Map', 'Report'];
  final List<Widget> _navScreens = const [
    NewsScreen(),
    HomeScreen(),
    MapsScreen(),
    ReportPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: const Color(0xFFB24D4D),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Container()),
              Text(
                _title[_selectedIndex],
                style: Theme.of(context).textTheme.displayLarge,
              ).onClick(() {
                FirebaseAuthService.logout();
              }).addRightMargin(20),
              Expanded(child: Container()),
              Icons.message
                  .toIcon(color: Color(0xFFB24D4D), size: 28)
                  .onClick(() {
                Navigator.of(context).pushNewPage(const AllChatsScreen());
              })
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _navScreens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.newspaper), label: _title[0]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: _title[1]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.map), label: _title[2]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.note_add), label: _title[3])
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFB24D4D),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/astronautpng1.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      gpc.read(currentRFUserProvider)!.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('To Do Mission'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const MyDashboard())));
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
