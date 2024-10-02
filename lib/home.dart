import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'index 0: List',
      ),
    ),
    Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'GYM BABARSARI MANTAP',
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Text(
        'index 2: Profile',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 74, 70, 83),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list,), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person,), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
