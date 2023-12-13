import 'package:flutter/material.dart';
import 'package:redfrontier/screens/home_screen.dart';
import 'package:redfrontier/screens/maps_screen.dart';
import 'package:redfrontier/screens/news_screen.dart';
import 'package:redfrontier/screens/report_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Red Frontier',
      //     style: Theme.of(context).textTheme.displayLarge,
      //   ),
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      // ),

      body: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
              color: const Color(0xFFB24D4D),
            ),
          ),
          title: Text(
            _title[_selectedIndex],
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _navScreens,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: _title[0]),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: _title[1]),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: _title[2]),
          BottomNavigationBarItem(icon: Icon(Icons.note_add), label: _title[3])
        ],
      ),
    );
  }
}
