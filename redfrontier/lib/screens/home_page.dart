import 'package:flutter/material.dart';

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

  final List<String> _title = ['News', 'Home', 'Map', 'SOS'];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.note_add),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            _title[_selectedIndex],
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: 'SOS')
        ],
      ),
    );
  }
}
